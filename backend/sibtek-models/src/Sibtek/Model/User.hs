-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

{-# LANGUAGE TemplateHaskell #-}

module Sibtek.Model.User
     ( UserModel (..)
     ) where

import           Data.Text (type Text)

import           Sibtek.Sugar
import           Sibtek.Model.Class


type UserModelSpec
  = IdentityField
  ⊳ ModelField "username"   Text "username"    '[]
  ⊳ ModelField "publicSalt" Text "public_salt" '[]

$(buildModelDataType "UserModel" (Proxy ∷ Proxy UserModelSpec))

instance Model UserModel where
  type DBTableName UserModel = "users"
  type FieldsSpec  UserModel = UserModelSpec
