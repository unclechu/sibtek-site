-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

{-# LANGUAGE TemplateHaskell #-}

module Sibtek.Model.User
     ( UserModel (..)
     , UserModelFieldsSpec
     ) where

import           Data.Text (type Text)

import           Sibtek.Sugar
import           Sibtek.Model.Class


type UserModelName = "UserModel"

type UserModelFieldsSpec
  = IdentityField
  ⊳ ModelField "username"   Text "username"    '[]
  ⊳ ModelField "publicSalt" Text "public_salt" '[]

$(buildModelDataType (Proxy ∷ Proxy UserModelName) (Proxy ∷ Proxy UserModelFieldsSpec))

instance Model UserModel where
  type ModelName   UserModel = UserModelName
  type DBTableName UserModel = "users"
  type FieldsSpec  UserModel = UserModelFieldsSpec
