-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}

module Sibtek.Model.Class.Fields
     ( type (⊳)
     , type ModelField
     , type IdentityField
     , type ExtendFieldsSpec
     , ModelFieldMeta (..)
     , ModelFieldsSpecShow (..)
     , SerializeFields (..)
     ) where

import           Data.Text (type Text)
import           Data.Typeable

import           Sibtek.Sugar


-- A combinator for type-level fields
data (a ∷ k) ⊳ b
infixr 5 ⊳

-- A type-level representation of a field.
--    * `fieldName` is a name for a record field
--    * `fieldType` is a type of a field
--    * `dbFieldName` is a name for a database field
--    * `meta` is list of additional meta info for a field
data (Typeable fieldType, KnownSymbol fieldName, KnownSymbol dbFieldName)
  ⇒ ModelField (fieldName ∷ Symbol)
               (fieldType ∷ *)
               (dbFieldName ∷ Symbol)
               (meta ∷ [ModelFieldMeta])

data ModelFieldMeta
  = MetaPrimaryKey

-- A shorthand for identity field which almost all model have
type IdentityField = ModelField "identity" Int "id" '[MetaPrimaryKey]


-- Few type-level functions to deal with field spec of a model

type family FieldsSpecToList spec where
  FieldsSpecToList (a ⊳ b) = a ': FieldsSpecToList b
  FieldsSpecToList (ModelField n t d m) = '[ModelField n t d m]

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

instance (Typeable t, KnownSymbol n, KnownSymbol d, ModelFieldMetaListShow m)
  ⇒ ModelFieldsSpecShow (ModelField n t d m)
  where
  modelFieldsSpecShow Proxy = [qms| {symbolVal (Proxy ∷ Proxy n)}
                                    ("{symbolVal (Proxy ∷ Proxy d)}")
                                    ∷ {typeOf (undefined ∷ t)}
                                    {modelFieldMetaListShow (Proxy ∷ Proxy m)} |]

instance (ModelFieldsSpecShow a, ModelFieldsSpecShow b) ⇒ ModelFieldsSpecShow (a ⊳ b) where
  modelFieldsSpecShow Proxy = [qmb| {modelFieldsSpecShow (Proxy ∷ Proxy a)}
                                    {modelFieldsSpecShow (Proxy ∷ Proxy b)} |]


class ModelFieldMetaListShow a where
  modelFieldMetaListShow ∷ Proxy a → Text
  modelFieldMetaListTailShow ∷ Proxy a → Text -- For internal use

instance ModelFieldMetaListShow '[] where
  modelFieldMetaListShow Proxy = "[]"
  modelFieldMetaListTailShow Proxy = ""

instance (ModelFieldMetaShowClass x, KnownSymbol (ModelFieldMetaShow x), ModelFieldMetaListShow xs)
  ⇒ ModelFieldMetaListShow ((x ∷ ModelFieldMeta) : xs)
  where

  modelFieldMetaListShow Proxy = [qm| [{symbolVal (Proxy ∷ Proxy (ModelFieldMetaShow x))}
                                       {modelFieldMetaListTailShow (Proxy ∷ Proxy xs)}] |]

  modelFieldMetaListTailShow Proxy = [qm| , {symbolVal (Proxy ∷ Proxy (ModelFieldMetaShow x))}
                                            {modelFieldMetaListTailShow (Proxy ∷ Proxy xs)} |]


class ModelFieldMetaShowClass (a ∷ ModelFieldMeta) where
  type ModelFieldMetaShow a ∷ Symbol

instance ModelFieldMetaShowClass MetaPrimaryKey where
  type ModelFieldMetaShow MetaPrimaryKey = "PrimaryKey"


class SerializeFields to spec where
  type SerializeFieldsType to
  serializeFields ∷ to → Proxy spec → SerializeFieldsType to
