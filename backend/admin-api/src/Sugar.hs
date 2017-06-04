-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

-- Only one module which whole export supposed to be imported implicitly.
-- So if you see any unknown type/function/operator it probably was declared here.

module Sugar
  ( module Prelude.Unicode
  , Generic
  , type (‣), type (‡), (‡), (∵)
  , (∘>), (&), (<&>), (|?|), (?)
  , ifMaybe, ifMaybeM, ifMaybeM'
  , applyIf, applyUnless
  , dupe
  , hexStr
  , qm
  ) where

import Prelude.Unicode
import GHC.Generics (Generic)

import Servant ((:>), (:<|>)((:<|>)), Context((:.)))

import Data.Function ((&))
import Data.Bool (bool)
import Data.ByteString.Char8 (ByteString)
import qualified Data.ByteString.Char8 as BS
import Text.Printf (printf)
import Text.InterpolatedString.QM (qm)

import Control.Monad ((>=>))


type (‣) = (:>)
infixr 9 ‣

type (‡) = (:<|>)
(‡) ∷ a → b → a :<|> b
(‡) = (:<|>)
infixr 8 ‡

(∵) ∷ x → Context xs → Context (x : xs)
(∵) = (:.)
infixr 5 ∵

(∘>) :: (a → b) → (b → c) → a → c
(∘>) = flip (.)
infixl 9 ∘>

(<&>) ∷ Functor f ⇒ f a → (a → b) → f b
(<&>) = flip (<$>)
infixr 5 <&>

(|?|) ∷ a → a → (Bool → a)
a |?| b = bool b a
infixl 2 |?|

(?) :: Bool → a → a → a
(?) True  x _ = x
(?) False _ y = y
infixl 1 ?


ifMaybe ∷ (a → Bool) → a → Maybe a
ifMaybe f x = f x ? Just x $ Nothing

ifMaybeM ∷ Monad m ⇒ (a → Bool) → m a → m (Maybe a)
ifMaybeM f m = m >>= \x → return $ f x ? Just x $ Nothing

ifMaybeM' ∷ Monad m ⇒ Bool → m a → m (Maybe a)
ifMaybeM' condition m = condition ? (Just <$> m) $ return Nothing


applyIf ∷ (a → a) → Bool → a → a
applyIf = (|?| id)

applyUnless ∷ (a → a) → Bool → a → a
applyUnless = (id |?|)


dupe ∷ a → (a, a)
dupe x = (x, x)


hexStr ∷ ByteString → String
hexStr = BS.unpack >=> printf "%02x"