-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

-- Only one module which whole export supposed to be imported implicitly.
-- So if you see any unknown type/function/operator it probably was declared here.

module Sibtek.Sugar
     ( module Prelude.Unicode
     , module GHC.TypeLits
     , module Data.Proxy
     , module Control.Monad
     , Generic
     , type 𝔹
     , type (‣), type (‡), (‡), (∵), (∴), (∴?), (∴!)
     , (•), (&), (<&>), (|?|), (?), (⋄)
     , preserve, preserve', preserveF, preserveF', preserveM, preserveM'
     , applyIf, applyUnless
     , dupe
     , hexStr
     , qm, qms, qmb
     , qn, qns, qnb
     , myToJSON
     ) where

import           Prelude.Unicode
import           GHC.Generics (Generic, Rep)
import           GHC.TypeLits

import           Data.Proxy
import           Data.Monoid (type Monoid, (<>))
import           Data.Aeson ((.:), (.:?), (.:!), genericToJSON, defaultOptions)

import           Data.Aeson.Types ( type Parser
                                  , type Object
                                  , type Value
                                  , type FromJSON
                                  , type GToJSON
                                  , type Zero
                                  , Options ( sumEncoding
                                            , allNullaryToStringTag
                                            , constructorTagModifier
                                            )
                                  , SumEncoding (UntaggedValue)
                                  , emptyObject
                                  )

import           Data.Text (type Text)
import           Data.Function ((&))
import           Data.Bool (bool)
import           Data.ByteString.Char8 (type ByteString)
import qualified Data.ByteString.Char8 as BS
import           Text.Printf (printf)

import           Text.InterpolatedString.QM ( qm, qms, qmb
                                            , qn, qns, qnb
                                            )

import           Control.Monad ((>=>), (<=<), guard)

import           Servant ((:>), (:<|>) ((:<|>)), Context ((:.)))


type 𝔹 = Bool

type (‣) = (:>)
infixr 9 ‣

type (‡) = (:<|>)
(‡) ∷ a → b → a :<|> b
(‡) = (:<|>)
infixr 8 ‡

(∵) ∷ x → Context xs → Context (x : xs)
(∵) = (:.)
infixr 5 ∵

(∴) ∷ FromJSON a ⇒ Object → Text → Parser a
(∴) = (.:)
(∴?) ∷ FromJSON a ⇒ Object → Text → Parser (Maybe a)
(∴?) = (.:?)
(∴!) ∷ FromJSON a ⇒ Object → Text → Parser (Maybe a)
(∴!) = (.:!)

-- See README.md
(•) ∷ (a → b) → (b → c) → a → c
(•) = flip (∘)
{-# INLINE (•) #-}
infixl 9 •

-- See README.md
(<&>) ∷ Functor f ⇒ f a → (a → b) → f b
(<&>) = flip (<$>)
{-# INLINE (<&>) #-}
infixr 5 <&>

-- See README.md
(|?|) ∷ a → a → (Bool → a)
(|?|) = flip bool
{-# INLINE (|?|) #-}
infixl 2 |?|

-- See README.md
(?) ∷ Bool → a → a → a
(?) True  x _ = x
(?) False _ y = y
{-# INLINE (?) #-}
infixl 1 ?

-- See README.md
(⋄) ∷ Monoid a ⇒ a → a → a
(⋄) = (<>)
{-# INLINE (⋄) #-}
infixr 6 ⋄


-- Kinda like a `guard`.
-- Consider this example: `\x → x <$ guard (x ≠ "")`
-- it could be replaced with: `preserve (≠ "")`.
-- Protects value with some condition and returns either value wrapped by `Just`
-- or `Nothing` if value isn't satisfies condition.
preserve ∷ (a → Bool) → a → Maybe a
preserve f x = if f x then Just x else Nothing
{-# INLINE preserve #-}

-- Like `preserve` but instead of predicate function just takes `Bool`.
-- So `preserve (const True)` could be replaced with `preserve' True`.
preserve' ∷ Bool → a → Maybe a
preserve' condition x = if condition then Just x else Nothing
{-# INLINE preserve' #-}

-- Functor version of `preserve`.
-- Consider this example: `preserve (≠ "") <$> getLine`
-- it could be replaced with: `preserveF (≠ "") getLine`.
-- Guards value inside a functor, returns wrapped `Maybe` value.
preserveF ∷ Functor f ⇒ (a → Bool) → f a → f (Maybe a)
preserveF f = fmap $ \x → if f x then Just x else Nothing
{-# INLINE preserveF #-}

-- Like `preserveF` but instead of predicate function just takes `Bool`.
-- So `preserveF (const True) getLine` could be replaced with `preserveF' True getLine`.
preserveF' ∷ Functor f ⇒ Bool → f a → f (Maybe a)
preserveF' condition = fmap $ if condition then Just else const Nothing
{-# INLINE preserveF' #-}

-- Like `preserve` but guards a value already wrapped with `Maybe`,
-- guards a value inside and fails (returns `Nothing`) if predicate gets `False`.
preserveM ∷ (a → Bool) → Maybe a → Maybe a
preserveM f m = m >>= \x → if f x then Just x else Nothing
{-# INLINE preserveM #-}

-- Like `preserveM` but instead of predicate function just takes `Bool`.
-- So `preserveM (const True)` could be replaced with `preserveM' True`.
preserveM' ∷ Bool → Maybe a → Maybe a
preserveM' condition m = if condition then m else Nothing
{-# INLINE preserveM' #-}


-- Gets a transformer function, a flag and a value.
-- Returns transformed value if flag is `True` otherwise returns original value.
applyIf ∷ (a → a) → Bool → a → a
applyIf = (|?| id)
{-# INLINE applyIf #-}

-- Negative version of `applyIf`
applyUnless ∷ (a → a) → Bool → a → a
applyUnless = (id |?|)
{-# INLINE applyUnless #-}


dupe ∷ a → (a, a)
dupe x = (x, x)
{-# INLINE dupe #-}


hexStr ∷ ByteString → String
hexStr = BS.unpack >=> printf "%02x"
{-# INLINE hexStr #-}


-- Custom implementation to return `{}` (empty object) instead of empty string
-- when constructor have no fields.
myToJSON ∷ (Generic a, GToJSON Zero (Rep a)) ⇒ a → Value
myToJSON = f • (\x → if x ≡ "" then emptyObject else x)
  where f = genericToJSON defaultOptions { sumEncoding            = UntaggedValue
                                         , allNullaryToStringTag  = False
                                         , constructorTagModifier = const ""
                                         }
