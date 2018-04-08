module Sibtek.DB.API
     ( DBConnection (..)
     , DBAPI (..)
     ) where

import           Sibtek.Sugar


data DBConnection impl conn = DBConnection conn

class DBAPI impl where
  type DBConnectionType impl
  type DBConnectRequest impl
  dbConnect ∷ impl → DBConnectRequest impl → IO (DBConnection impl (DBConnectionType impl))
  dbDisconnect ∷ DBConnection impl (DBConnectionType impl) → IO ()
