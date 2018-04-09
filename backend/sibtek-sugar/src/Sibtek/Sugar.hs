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
     , ifMaybe, ifMaybeM, ifMaybeM'
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
-- it could be replaced with: `ifMaybe (≠ "")`.
-- Protects value with some condition and returns either value wrapped by `Just`
-- or `Nothing` if value isn't satisfies condition.
ifMaybe ∷ (a → Bool) → a → Maybe a
ifMaybe f x = if f x then Just x else Nothing
{-# INLINE ifMaybe #-}

-- Monadic version of `ifMaybe`.
-- Consider this example: `ifMaybe (≠ "") <$> getLine`
-- it could be replaced with: `ifMaybeM (≠ "") getLine`.
-- Guards value inside a monad, returns monad of `Maybe`.
ifMaybeM ∷ Monad m ⇒ (a → Bool) → m a → m (Maybe a)
ifMaybeM f m = m >>= (\x → return $ if f x then Just x else Nothing)
{-# INLINE ifMaybeM #-}

-- Like `ifMaybeM` but instead of predicate function just takes `Bool`.
-- So `ifMaybeM (const True) getLine` could be replaced with `ifMaybeM' True getLine`.
ifMaybeM' ∷ Monad m ⇒ Bool → m a → m (Maybe a)
ifMaybeM' condition m = if condition then Just <$> m else return Nothing
{-# INLINE ifMaybeM' #-}


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
