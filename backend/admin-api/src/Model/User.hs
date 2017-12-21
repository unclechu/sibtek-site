-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Model.User
  ( UserModel (..)
  , TestParentModel (..)
  , TestParentModelSpec
  , UserModelSpec
  ) where

import           Data.Text (type Text)
import           Model.Class

-- local imports
import           Sugar


type TestParentModelSpec
  = IdentityField

data TestParentModel = TestParentModel
instance Model TestParentModel where
  type DBTableName TestParentModel = "TESTING STUFF"


type UserModelSpec
  = IdentityField
  ⊳ ModelField "username" Text "username"
  ⊳ ModelField "publicSalt" Text "public_salt"

data UserModel
  = UserModel
  { username   ∷ Text
  , publicSalt ∷ Text
  }

instance Model UserModel where
  type DBTableName UserModel = "users"
  type Parent UserModel = 'Just TestParentModel
  parentModel = ParentModel undefined
