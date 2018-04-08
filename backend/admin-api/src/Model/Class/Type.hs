-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Model.Class.Type
     ( ParentModel (..)
     , ModelIdentity (..)
     , Model (..)
     ) where

import           GHC.TypeLits

import           Data.Typeable


data ParentModel m where
  NoParentModel ∷ ParentModel m
  ParentModel   ∷ (Model p, Parent m ~ 'Just p) ⇒ ModelIdentity p → ParentModel m


data Model m ⇒ ModelIdentity m = ModelIdentity


class (KnownSymbol (DBTableName m), Typeable m) ⇒ Model m where

  type DBTableName m ∷ Symbol

  -- If model have parent `Parent` must be overwritten by with:
  -- `type Parent FooModel = 'Just ParentModelOfFooModel`
  type Parent m ∷ Maybe *
  type Parent m = 'Nothing

  -- If model have parent `FieldsSpec` supposed to be extended from parent `FieldsSpec`:
  --
  -- ```
  -- type FooModelSpec
  --   = ExtendFieldsSpec (FieldsSpec ParentModelOfFooModel)
  --   ( ModelField "foo" Text "foo_db_field"
  --   ⊳ ModelField "bar" Text "bar_db_field"
  --   )
  -- ```
  type FieldsSpec m ∷ *

  modelIdentity ∷ ModelIdentity m
  modelIdentity = ModelIdentity

  -- If model have parent `parentModel` must be overwritten by with:
  -- `parentModel = ParentModel undefined`
  parentModel ∷ ParentModel m
  parentModel = NoParentModel

  modelName ∷ ModelIdentity m → String
  modelName ModelIdentity = show $ typeOf (undefined ∷ m)
