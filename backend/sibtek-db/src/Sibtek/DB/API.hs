-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Sibtek.DB.API
     ( DBConnection (..)
     , DBTableCreator (..)
     , DBAPI (..)
     , type DBSerializers
     ) where

import           Data.Kind (type Constraint)

import           Sibtek.Sugar
import           Sibtek.Model.Class


newtype DBConnection   impl conn    = DBConnection   { unwrapDBConnection   ∷ conn }
newtype DBTableCreator impl creator = DBTableCreator { unwrapDBTableCreator ∷ creator }


-- `impl` is for 'implementation'
class DBAPI impl where
  type DBConnectionType            impl
  type DBConnectRequest            impl
  type DBTableCreatorType          impl
  type DBToTableCreatorSerializers impl ∷ [*] -- For constraints injecting

  dbConnect ∷ impl → DBConnectRequest impl → IO (DBConnection impl (DBConnectionType impl))
  dbDisconnect ∷ DBConnection impl (DBConnectionType impl) → IO ()

  getTableCreator
    ∷ ∀ m . (Model m, DBSerializers (DBToTableCreatorSerializers impl) m)
    ⇒ impl → ModelIdentity m → DBTableCreator impl (DBTableCreatorType impl)


type family DBSerializers serializers model ∷ Constraint where
  DBSerializers '[] _ = ()
  DBSerializers (x ': xs) m = (SerializeFields x (FieldsSpec m), DBSerializers xs m)
