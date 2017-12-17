-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Model.Class
  ( Model (..)
  ) where

import           GHC.TypeLits
-- import           Data.Typeable (TypeRep)

class Model m where
  type DBTableName m ∷ Symbol

-- data ModelField = ModelField TypeRep String
