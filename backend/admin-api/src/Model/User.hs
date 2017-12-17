-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Model.User
  ( UserModel (..)
  ) where

import           Model.Class (Model (..), getModelInfo)


data UserModel
  = UserModel
  { username   ∷ String
  , publicSalt ∷ String
  }

instance Model UserModel where
  type DBTableName UserModel = "users"
