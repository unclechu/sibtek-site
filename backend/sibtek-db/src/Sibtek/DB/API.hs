-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Sibtek.DB.API
     ( DBConnection (..)
     , DBTableCreator (..)
     , DBAPI (..)
     ) where

import           Sibtek.Sugar
import           Sibtek.Model.Class


newtype DBConnection   impl conn    = DBConnection   { unwrapDBConnection   ∷ conn }
newtype DBTableCreator impl creator = DBTableCreator { unwrapDBTableCreator ∷ creator }

-- `impl` is for 'implementation'
class DBAPI impl where
  type DBConnectionType   impl
  type DBConnectRequest   impl
  type DBTableCreatorType impl
  type DBToTableCreator   impl

  dbConnect ∷ impl → DBConnectRequest impl → IO (DBConnection impl (DBConnectionType impl))
  dbDisconnect ∷ DBConnection impl (DBConnectionType impl) → IO ()

  getTableCreator
    ∷ ∀ m . (Model m, SerializeFields (DBToTableCreator impl) (FieldsSpec m))
    ⇒ impl → ModelIdentity m → DBTableCreator impl (DBTableCreatorType impl)
