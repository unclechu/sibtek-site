-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

{-# LANGUAGE TemplateHaskell #-}

module Sibtek.Model.Page
     ( PageModel (..)
     , PageModelFieldsSpec
     ) where

import           Data.Text (type Text)

import           Sibtek.Sugar
import           Sibtek.Model.Class


type PageModelName = "PageModel"

type PageModelFieldsSpec
  = IdentityField
  ⊳ ModelField "isActive"     Bool "is_active" '[]
  ⊳ ModelField "header"       Text "header" '[]
  ⊳ ModelField "symbolicCode" Text "symbolic_code" '[MetaUnique]

$(buildModelDataType (Proxy ∷ Proxy PageModelName) (Proxy ∷ Proxy PageModelFieldsSpec))

instance Model PageModel where
  type ModelName   PageModel = PageModelName
  type DBTableName PageModel = "pages"
  type FieldsSpec  PageModel = PageModelFieldsSpec
