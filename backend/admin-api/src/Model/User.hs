-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE TemplateHaskell #-}

module Model.User
     ( UserModel (..)
     , TestParentModel (..)
     ) where

import           Data.Text (type Text)
import           Data.Proxy
import           Model.Class
import           Model.FieldsBuilder


data TestParentModel = TestParentModel
instance Model TestParentModel where
  type DBTableName TestParentModel = "TESTING STUFF"

  type FieldsSpec TestParentModel
    = IdentityField
    ⊳ ModelField "foo" Text "foo"
    ⊳ ModelField "bar" Text "bar"


type UserModelParent = TestParentModel

type UserModelSpec
  = ExtendFieldsSpec (FieldsSpec UserModelParent)
  ( ModelField "username"   Text "username"
  ⊳ ModelField "publicSalt" Text "public_salt"
  )

$(buildModelDataType "UserModel" (Proxy ∷ Proxy UserModelSpec))

teststuff = UserModel { username = "testing" }

instance Model UserModel where
  type DBTableName UserModel = "users"
  type Parent UserModel = 'Just UserModelParent
  type FieldsSpec UserModel = UserModelSpec
  parentModel = ParentModel undefined
