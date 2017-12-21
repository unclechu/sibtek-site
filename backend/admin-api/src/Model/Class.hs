-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Model.Class
  ( Model (..)
  , ModelInfo (..)
  , ParentModel (..)
  , ModelIdentity
  , ModelField (..)
  , type IdentityField
  , type (⊳)
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
  ParentModel   ∷ (Model p, Parent m ~ 'Just p) ⇒ ModelIdentity p → ParentModel m


data Model m ⇒ ModelInfo m
  = ModelInfo
  { modelName       ∷ Text
  , tableName       ∷ Text
  , parentModelName ∷ Maybe Text
  }


data Model m ⇒ ModelIdentity m

class (KnownSymbol (DBTableName m), Typeable m) ⇒ Model m where

  type DBTableName m ∷ Symbol

  type Parent m ∷ Maybe *
  type Parent m = 'Nothing

  modelIdentity ∷ ModelIdentity m
  modelIdentity = undefined

  modelInfo ∷ ModelInfo m
  modelInfo = getModelInfo

  parentModel ∷ ParentModel m
  parentModel = NoParentModel


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


data (a ∷ k) ⊳ b deriving Typeable
infixr 5 ⊳

data (Typeable t, KnownSymbol n)
  ⇒ ModelField t (n ∷ Symbol)
  = ModelField {modelFieldValue ∷ t}
  | EndOfModelFields
  deriving Typeable

type IdentityField = ModelField Int "id"
