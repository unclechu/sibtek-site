-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

{-# LANGUAGE UndecidableInstances #-}

module Sibtek.Model.Class.Fields
     ( type (⊳)
     , type ModelField
     , type IdentityField
     , type ExtendFieldsSpec
     , ModelFieldsSpecShow (..)
     ) where

import           Data.Text (type Text)
import           Data.Typeable

import           Sibtek.Sugar


-- A combinator for type-level fields
data (a ∷ k) ⊳ b
infixr 5 ⊳

-- A type-level representation of a field.
--    * `n` is a name for a record field
--    * `t` is a type of a field
--    * `d` is a name for a database field
data (Typeable t, KnownSymbol n, KnownSymbol d)
  ⇒ ModelField (n ∷ Symbol) (t ∷ *) (d ∷ Symbol)

-- A shorthand for identity field which almost all model have
type IdentityField = ModelField "identity" Int "id"


-- Few type-level functions to deal with field spec of a model

type family FieldsSpecToList spec where
  FieldsSpecToList (a ⊳ b) = a ': FieldsSpecToList b
  FieldsSpecToList (ModelField n t d) = '[ModelField n t d]

type family MergeFieldsSpecLists parent child where
  MergeFieldsSpecLists '[] acc = acc
  MergeFieldsSpecLists (x ': xs) acc = x ': MergeFieldsSpecLists xs acc

type family ListToFieldsSpec list where
  ListToFieldsSpec (x ': '[]) = x
  ListToFieldsSpec (x ': xs)  = x ⊳ ListToFieldsSpec xs

type family ExtendFieldsSpec parent child where
  ExtendFieldsSpec p c =
    ListToFieldsSpec (MergeFieldsSpecLists (FieldsSpecToList p) (FieldsSpecToList c))


class ModelFieldsSpecShow a where
  modelFieldsSpecShow ∷ Proxy a → Text

instance (Typeable t, KnownSymbol n, KnownSymbol d) ⇒ ModelFieldsSpecShow (ModelField n t d) where
  modelFieldsSpecShow Proxy = [qms| {symbolVal (Proxy ∷ Proxy n)}
                                    ("{symbolVal (Proxy ∷ Proxy d)}")
                                    ∷ {typeOf (undefined ∷ t)} |]

instance (ModelFieldsSpecShow a, ModelFieldsSpecShow b) ⇒ ModelFieldsSpecShow (a ⊳ b) where
  modelFieldsSpecShow Proxy = [qmb| {modelFieldsSpecShow (Proxy ∷ Proxy a)}
                                    {modelFieldsSpecShow (Proxy ∷ Proxy b)} |]
