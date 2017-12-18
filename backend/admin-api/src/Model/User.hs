-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Model.User
  ( UserModel (..)
  ) where

import           Data.Text (type Text)
import           Model.Class (Model (..))


-- import Model.Class (ModelIdentity, ParentModel (..))
-- data TestParentModel = TestParentModel
-- instance Model TestParentModel where
--   type DBTableName TestParentModel = "TESTING STUFF"


data UserModel
  = UserModel
  { username   ∷ Text
  , publicSalt ∷ Text
  }

instance Model UserModel where
  type DBTableName UserModel = "users"

  -- type Parent UserModel = TestParentModel
  -- parentModel = ParentModel (modelIdentity ∷ ModelIdentity TestParentModel)
