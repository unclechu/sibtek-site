-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Sibtek.Model.Class.Type
     ( ParentModel (..)
     , ModelIdentity (..)
     , Model (..)
     ) where

import           Data.Typeable

import           Sibtek.Sugar


data Model m ⇒ ModelIdentity m = ModelIdentity


data ParentModel m where
  NoParentModel ∷ ParentModel m
  ParentModel   ∷ (Model p, Parent m ~ 'Just p) ⇒ ModelIdentity p → ParentModel m


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
  --
  -- …
  --
  -- type FieldsSpec FooModel = FooModelSpec
  -- ```
  type FieldsSpec m ∷ *

  modelIdentity ∷ ModelIdentity m
  modelIdentity = ModelIdentity

  -- If model have parent `parentModel` must be overwritten by with:
  -- `parentModel = ParentModel ModelIdentity`
  parentModel ∷ ParentModel m
  parentModel = NoParentModel

  modelName ∷ ModelIdentity m → String
  modelName ModelIdentity = show $ typeOf (undefined ∷ m)
