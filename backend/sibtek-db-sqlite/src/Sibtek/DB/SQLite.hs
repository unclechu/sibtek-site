-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Sibtek.DB.SQLite
     ( SQLite (SQLite)
     ) where

import           Data.Text (type Text)

import qualified Database.SQLite.Simple as DB

import           Sibtek.Sugar
import           Sibtek.DB.API
import           Sibtek.Model.Class


data SQLite = SQLite

instance DBAPI SQLite where
  type DBConnectRequest   SQLite = FilePath
  type DBConnectionType   SQLite = DB.Connection
  type DBTableCreatorType SQLite = Text

  dbConnect SQLite = DB.open • fmap DBConnection
  dbDisconnect (DBConnection conn) = DB.close conn

  getTableCreator SQLite x@(ModelIdentity ∷ ModelIdentity m) =
    DBTableCreator [qmb|
      -- {modelName x}
      CREATE TABLE "{symbolVal (Proxy ∷ Proxy (DBTableName m))}" (
        -- TODO fields spec
      );
    |]
