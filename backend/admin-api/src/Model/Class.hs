-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

{-# LANGUAGE UndecidableInstances #-}

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
import           Data.Type.Bool

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

class (HasParentModel (HasParent m), KnownSymbol (DBTableName m), Typeable m) ⇒ Model m where

  type DBTableName m ∷ Symbol
  type Parent      m ∷ Maybe *

  type HasParent m ∷ Bool
  type HasParent m = IsJust (Parent m)

  modelIdentity ∷ ModelIdentity m
  modelIdentity = undefined

  modelInfo ∷ ModelInfo m
  modelInfo = getModelInfo

  parentModel ∷ ParentModel m
  parentModel = extractParentModel (Proxy ∷ Proxy (HasParent m))


class    HasParentModel (a ∷ Bool) where extractParentModel ∷ ∀ m . Proxy a → ParentModel m
instance HasParentModel False      where extractParentModel Proxy = NoParentModel
-- TODO FIXME `ParentModel undefined` is gets error:
--            "Couldn't match type ‘Parent m’ with ‘'Just p0’ arising
--            from a use of ‘ParentModel’ The type variable ‘p0’ is ambiguous"
-- instance HasParentModel True       where extractParentModel Proxy = ParentModel undefined
instance HasParentModel True       where extractParentModel Proxy = NoParentModel


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
