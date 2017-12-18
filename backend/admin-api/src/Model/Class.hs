-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE RankNTypes #-}

module Model.Class
  ( Model (..)
  , ModelInfo (..)
  , ParentModel (..)
  , ModelIdentity
  , NoneModel
  , getModelInfo
  ) where

import           GHC.TypeLits

import           Data.Text (type Text)
import qualified Data.Text as T
import           Data.Proxy
import           Data.Typeable


data ParentModel m where
  NoParentModel ∷ ParentModel m
  ParentModel   ∷ (Model p, Model m, p ~ Parent m) ⇒ ModelIdentity p → ParentModel m


-- TODO Type-level Maybe could be used instead of this
data NoneModel
instance Model NoneModel where
  type DBTableName NoneModel = "(undefined)"
  modelInfo = error "ModelInfo NoneModel"


data Model m ⇒ ModelInfo m
  = ModelInfo
  { modelName       ∷ Text
  , tableName       ∷ Text
  , parentModelName ∷ Maybe Text
  }


data Model m ⇒ ModelIdentity m


class (KnownSymbol (DBTableName m), Typeable m) ⇒ Model m where

  type DBTableName m ∷ Symbol

  type Parent m
  type Parent m = NoneModel

  modelIdentity ∷ ModelIdentity m
  modelIdentity = undefined

  modelInfo ∷ ModelInfo m
  modelInfo = getModelInfo modelIdentity

  parentModel ∷ ParentModel m
  parentModel = NoParentModel


-- data ModelField = ModelField TypeRep String


getModelInfo ∷ ∀ m . Model m ⇒ ModelIdentity m → ModelInfo m
getModelInfo _
  = ModelInfo
  { modelName = T.pack $ show $ typeOf (undefined ∷ m)
  , tableName = T.pack $ symbolVal (Proxy ∷ Proxy (DBTableName m))

  , parentModelName =
      case (parentModel ∷ ParentModel m) of
           NoParentModel → Nothing
           ParentModel (_ ∷ ModelIdentity p) → Just $ modelName (modelInfo ∷ ModelInfo p)
  }
