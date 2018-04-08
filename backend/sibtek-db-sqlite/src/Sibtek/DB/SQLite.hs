module Sibtek.DB.SQLite
     ( SQLite (SQLite)
     ) where

import qualified Database.SQLite.Simple as DB

import           Sibtek.Sugar
import           Sibtek.DB.API


data SQLite = SQLite

instance DBAPI SQLite where
  type DBConnectRequest SQLite = FilePath
  type DBConnectionType SQLite = DB.Connection
  dbConnect SQLite = DB.open • fmap DBConnection
  dbDisconnect (DBConnection conn) = DB.close conn
