-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Model.User
  ( UserModel (..)
  , TestParentModel (..)
  ) where

import           Data.Text (type Text)
import           Model.Class

-- local imports
import           Sugar


data TestParentModel = TestParentModel
instance Model TestParentModel where
  type DBTableName TestParentModel = "TESTING STUFF"
  type Parent TestParentModel = 'Nothing


data UserModel
  = UserModel
  { username   ∷ Text
  , publicSalt ∷ Text
  }

instance Model UserModel where
  type DBTableName UserModel = "users"
  type Parent UserModel = 'Just TestParentModel
