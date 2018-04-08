-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

{-# LANGUAGE TemplateHaskell #-}

module Sibtek.Model.Class.FieldsBuilder
     ( buildModelDataType
     ) where

import           Data.Typeable
import           Data.Either (either)

import           Control.Arrow ((&&&))

import qualified Language.Haskell.TH as TH
import           Language.Haskell.TH.Syntax as TH (VarBangType)
import           Language.Haskell.Meta.Parse (parseType)

import           Sibtek.Sugar
import           Sibtek.Model.Class.Fields


-- This helps to produce a data-type for a model by field spec.
-- This also defines partial version of constructor, consider this example:
--
--   type FooModelSpec
--     = IdentityField
--     ⊳ ModelField "foo" Text         "foo_db_field"
--     ⊳ ModelField "bar" (Maybe Text) "bar_db_field"
--
--   $(buildModelDataType "FooModel" (Proxy ∷ Proxy FooModelSpec))
--
-- Will give you:
--
--   data FooModel
--     = FooModel { foo ∷ Text, bar ∷ Maybe Text }
--     | FooModelPartial { fooPartial ∷ Maybe Text, barPartial ∷ Maybe (Maybe Text) }
--
-- You could see that every partial version of a field wrapped with `Maybe`.
buildModelDataType ∷ ModelFieldTH spec ⇒ String → Proxy spec → TH.DecsQ
buildModelDataType ((TH.mkName &&& TH.mkName ∘ (⧺ "Partial")) → (name, namePartial)) fieldsSpec
  = pure [TH.DataD [] name [] Nothing constructors []]
  where
    fields        = modelFieldTH False fieldsSpec
    fieldsPartial = modelFieldTH True  fieldsSpec

    constructors  = [ TH.RecC name        fields
                    , TH.RecC namePartial fieldsPartial
                    ]


class ModelFieldTH a where
  modelFieldTH ∷ 𝔹 → Proxy a → [TH.VarBangType]

instance (Typeable t, KnownSymbol n, KnownSymbol d) ⇒ ModelFieldTH (ModelField n t d) where
  modelFieldTH isPartial Proxy = (:[])
    ( TH.mkName $ [qm| {symbolVal (Proxy ∷ Proxy n)}{isPartial ? "Partial" $ "" ∷ String} |]
    , bangPlug
    , either error id $ parseType $ [qm| {isPartial ? "Maybe (" $ "" ∷ String}
                                         {typeOf (undefined ∷ t)}
                                         {isPartial ? ")" $ "" ∷ String} |]
    )

instance (ModelFieldTH a, ModelFieldTH b) ⇒ ModelFieldTH (a ⊳ b) where
  modelFieldTH isPartial Proxy
    = modelFieldTH isPartial (Proxy ∷ Proxy a)
    ⧺ modelFieldTH isPartial (Proxy ∷ Proxy b)


bangPlug ∷ TH.Bang
bangPlug = TH.Bang TH.NoSourceUnpackedness TH.NoSourceStrictness
