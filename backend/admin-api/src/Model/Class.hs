-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

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


data ParentModel m where
  NoParentModel ∷ ParentModel m
  ParentModel   ∷ (Model p, Model m, p ~ Parent m) ⇒ ModelIdentity p → ParentModel m

data NoneModel
instance Model NoneModel where
  type DBTableName NoneModel = "(undefined)"
  modelInfo = error "ModelInfo NoneModel"

data Model m ⇒ ModelInfo m
  = ModelInfo
  { modelName       ∷ Text
  , parentModelName ∷ Text
  , tableName       ∷ Text
  }

data Model m ⇒ ModelIdentity m

class Model m where

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
getModelInfo model
  = ModelInfo
  { modelName        = undefined
  , parentModelName  = undefined
  , tableName        = undefined
  }
