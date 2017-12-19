-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

-- Only one module which whole export supposed to be imported implicitly.
-- So if you see any unknown type/function/operator it probably was declared here.

module Sugar
  ( module Prelude.Unicode
  , Generic
  , type (‣), type (‡), (‡), (∵), (∴), (∴?), (∴!)
  , (•), (&), (<&>), (|?|), (?)
  , ifMaybe, ifMaybeM, ifMaybeM'
  , applyIf, applyUnless
  , dupe
  , hexStr
  , qm, qms, qmb
  , qn, qns, qnb
  , myToJSON
  , IsJust (..)
  ) where

import           Prelude.Unicode
import           GHC.Generics (Generic, Rep)

import           Servant ((:>), (:<|>) ((:<|>)), Context ((:.)))

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

import           Data.Text (Text)
import           Data.Function ((&))
import           Data.Bool (bool)
import           Data.ByteString.Char8 (type ByteString)
import qualified Data.ByteString.Char8 as BS
import           Text.Printf (printf)
import           Text.InterpolatedString.QM ( qm, qms, qmb
                                            , qn, qns, qnb
                                            )

import           Control.Monad ((>=>))


type family IsJust (a ∷ Maybe k) ∷ Bool where
  IsJust Nothing = False
  IsJust _       = True

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

(•) ∷ (a → b) → (b → c) → a → c
(•) = flip (∘)
{-# INLINE (•) #-}
infixl 9 •

(<&>) ∷ Functor f ⇒ f a → (a → b) → f b
(<&>) = flip (<$>)
{-# INLINE (<&>) #-}
infixr 5 <&>

(|?|) ∷ a → a → (Bool → a)
(|?|) = flip bool
{-# INLINE (|?|) #-}
infixl 2 |?|

(?) ∷ Bool → a → a → a
(?) True  x _ = x
(?) False _ y = y
{-# INLINE (?) #-}
infixl 1 ?


ifMaybe ∷ (a → Bool) → a → Maybe a
ifMaybe f x = if f x then Just x else Nothing
{-# INLINE ifMaybe #-}

ifMaybeM ∷ Monad m ⇒ (a → Bool) → m a → m (Maybe a)
ifMaybeM f m = m >>= (\x → return $ if f x then Just x else Nothing)
{-# INLINE ifMaybeM #-}

ifMaybeM' ∷ Monad m ⇒ Bool → m a → m (Maybe a)
ifMaybeM' condition m = if condition then Just <$> m else return Nothing
{-# INLINE ifMaybeM' #-}


applyIf ∷ (a → a) → Bool → a → a
applyIf = (|?| id)
{-# INLINE applyIf #-}

applyUnless ∷ (a → a) → Bool → a → a
applyUnless = (id |?|)
{-# INLINE applyUnless #-}


dupe ∷ a → (a, a)
dupe x = (x, x)
{-# INLINE dupe #-}


hexStr ∷ ByteString → String
hexStr = BS.unpack >=> printf "%02x"
{-# INLINE hexStr #-}


myToJSON ∷ (Generic a, GToJSON Zero (Rep a)) ⇒ a → Value
myToJSON = f • (\x → if x ≡ "" then emptyObject else x)
  where f = genericToJSON defaultOptions { sumEncoding            = UntaggedValue
                                         , allNullaryToStringTag  = False
                                         , constructorTagModifier = const ""
                                         }
