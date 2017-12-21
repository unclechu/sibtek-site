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
  , ModelSpecShow (..)
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
  } deriving Show


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

data (Typeable t, KnownSymbol n, KnownSymbol d)
  ⇒ ModelField (n ∷ Symbol) (t ∷ *) (d ∷ Symbol)
  = ModelField t
  deriving Typeable

type IdentityField = ModelField "identity" Int "id"


class ModelSpecShow a where
  modelSpecShow ∷ Proxy a → Text

instance (Typeable t, KnownSymbol n, KnownSymbol d) ⇒ ModelSpecShow (ModelField n t d) where
  modelSpecShow Proxy = [qms| {symbolVal (Proxy ∷ Proxy n)}
                              ("{symbolVal (Proxy ∷ Proxy d)}")
                              ∷ {typeOf (undefined ∷ t)} |]

instance (ModelSpecShow a, ModelSpecShow b) ⇒ ModelSpecShow (a ⊳ b) where
  modelSpecShow Proxy = [qmb| {modelSpecShow (Proxy ∷ Proxy a)}
                              {modelSpecShow (Proxy ∷ Proxy b)} |]
