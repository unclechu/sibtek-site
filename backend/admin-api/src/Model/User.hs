-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Model.User
  ( UserModel (..)
  ) where

import           Data.Text (type Text)
import           Model.Class (Model (..))

-- local imports
import           Sugar


import Model.Class (ModelIdentity, ParentModel (..))
data TestParentModel = TestParentModel
instance Model TestParentModel where
  type DBTableName TestParentModel = "TESTING STUFF"
  type Parent TestParentModel = 'TNothing


data UserModel
  = UserModel
  { username   ∷ Text
  , publicSalt ∷ Text
  }

instance Model UserModel where
  type DBTableName UserModel = "users"
  type Parent UserModel = 'TJust TestParentModel
  parentModel = ParentModel modelIdentity
