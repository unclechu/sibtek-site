-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

{-# LANGUAGE RankNTypes #-}

module Sibtek.Model
     ( modelMap
     , module Sibtek.Model.Class
     , module Sibtek.Model.User
     ) where

import qualified Data.Map as Map
import qualified Data.Text as T

import           Sibtek.Sugar
import           Sibtek.Model.Class
import           Sibtek.Model.User


modelMap ∷ ∀ a . (∀ m . Model m ⇒ ModelIdentity m → a) → Map.Map T.Text a
modelMap mapFn = modelMap'
  where
    mapModel ∷ Model m ⇒ ModelIdentity m → (T.Text, a)
    mapModel m = (modelName m, mapFn m)

    modelMap' = Map.fromList
      [ mapModel (ModelIdentity ∷ ModelIdentity UserModel)
      ]
