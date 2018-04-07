-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE FlexibleInstances #-}

module Model.FieldsBuilder
     ( buildModelDataType
     ) where

import           Prelude.Unicode
import           GHC.TypeLits

import           Data.Proxy
import           Data.Typeable
import           Data.Either (either)

import qualified Language.Haskell.TH as TH
import           Language.Haskell.TH.Syntax as TH (VarBangType)
import           Language.Haskell.Meta.Parse (parseType)

-- local imports
import           Model.Class


-- This helps to produce a data-type for a model by field spec
buildModelDataType ∷ ModelFieldTH spec ⇒ String → Proxy spec → TH.DecsQ
buildModelDataType (TH.mkName → n) fieldsSpec =
  pure [TH.DataD [] n [] Nothing [TH.RecC n fields] []]
  where fields = modelFieldTH fieldsSpec


class ModelFieldTH a where
  modelFieldTH ∷ Proxy a → [TH.VarBangType]

instance (Typeable t, KnownSymbol n, KnownSymbol d) ⇒ ModelFieldTH (ModelField n t d) where
  modelFieldTH Proxy = (:[])
    ( TH.mkName $ symbolVal (Proxy ∷ Proxy n)
    , bangPlug
    , either error id $ parseType $ show $ typeOf (undefined ∷ t)
    )

instance (ModelFieldTH a, ModelFieldTH b) ⇒ ModelFieldTH (a ⊳ b) where
  modelFieldTH Proxy = modelFieldTH (Proxy ∷ Proxy a) ⧺ modelFieldTH (Proxy ∷ Proxy b)


bangPlug ∷ TH.Bang
bangPlug = TH.Bang TH.NoSourceUnpackedness TH.NoSourceStrictness
