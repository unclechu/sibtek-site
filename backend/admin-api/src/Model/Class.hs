-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

{-# LANGUAGE RankNTypes #-}

{-# LANGUAGE PolyKinds #-}

module Model.Class
  ( Model (..)
  , ModelInfo (..)
  , ParentModel (..)
  , ModelIdentity
  ) where

import           GHC.TypeLits

import           Data.Text (type Text)
import qualified Data.Text as T
import           Data.Proxy
import           Data.Typeable

-- local imports
import           Sugar


data ParentModel m where
  NoParentModel ∷ ParentModel m
  ParentModel   ∷ (Model p, Model m, Parent m ~ 'TJust p) ⇒ ModelIdentity p → ParentModel m


data Model m ⇒ ModelInfo m
  = ModelInfo
  { modelName       ∷ Text
  , tableName       ∷ Text
  , parentModelName ∷ Maybe Text
  }


data Model m ⇒ ModelIdentity m


class (KnownSymbol (DBTableName m), Typeable m) ⇒ Model m where

  type DBTableName m ∷ Symbol
  type Parent      m ∷ TMaybe *

  modelIdentity ∷ ModelIdentity m
  modelIdentity = undefined

  modelInfo ∷ ModelInfo m
  modelInfo = getModelInfo

  parentModel ∷ ParentModel m
  parentModel = NoParentModel


-- data ModelField = ModelField TypeRep String


getModelInfo ∷ ∀ m . Model m ⇒ ModelInfo m
getModelInfo
  = ModelInfo
  { modelName = T.pack $ show $ typeOf (undefined ∷ m)
  , tableName = T.pack $ symbolVal (Proxy ∷ Proxy (DBTableName m))

  , parentModelName =
      case (parentModel ∷ ParentModel m) of
           NoParentModel → Nothing
           ParentModel (_ ∷ ModelIdentity p) → Just $ modelName (modelInfo ∷ ModelInfo p)
  }
