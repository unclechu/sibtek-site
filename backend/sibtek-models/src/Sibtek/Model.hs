-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

{-# LANGUAGE RankNTypes #-}

module Sibtek.Model
     ( modelMap
     , module Sibtek.Model.Class
     , module Sibtek.Model.User
     , type Models
     ) where

import qualified Data.Map as Map
import qualified Data.Text as T

import           Sibtek.Sugar
import           Sibtek.Model.Class
import           Sibtek.Model.User


type Models =
  '[ UserModel
   ]

-- type family FieldsSpecByModelName (model ∷ *) (specMap ∷ [(*, *)]) ∷ * where
--   FieldsSpecByModelName k ('(k, v) ': _) = v
--   FieldsSpecByModelName k (_ ': xs)      = FieldsSpecByModelName k xs


modelMap ∷ ∀ a . (∀ m . Model m ⇒ ModelIdentity m → a) → Map.Map T.Text a
modelMap mapFn = modelMap'
  where
    mapModel ∷ ∀ m . Model m ⇒ ModelIdentity m → (T.Text, a)
    mapModel model = (T.pack $ symbolVal (Proxy ∷ Proxy (ModelName m)), mapFn model)

    modelMap' = Map.fromList
      [ mapModel (ModelIdentity ∷ ModelIdentity UserModel)
      ]
