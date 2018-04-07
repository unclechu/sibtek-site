-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

{-# LANGUAGE TemplateHaskell #-}

module Model.User
     ( UserModel (..)
     ) where

import           Data.Text (type Text)
import           Data.Proxy
import           Model.Class
import           Model.FieldsBuilder


type UserModelSpec
  = IdentityField
  ⊳ ModelField "username"   Text "username"
  ⊳ ModelField "publicSalt" Text "public_salt"

$(buildModelDataType "UserModel" (Proxy ∷ Proxy UserModelSpec))

instance Model UserModel where
  type DBTableName UserModel = "users"
  type FieldsSpec  UserModel = UserModelSpec
