-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

{-# LANGUAGE MultiParamTypeClasses #-}

module Sibtek.DB.SQLite
     ( SQLite (SQLite)
     , ToCreateTableSQL (ToCreateTableSQL)
     ) where

import           GHC.Generics

import           Data.Text (type Text)
import qualified Data.Text as T
import           Data.Typeable (type Typeable)

import qualified Database.SQLite.Simple as DB

import           Sibtek.Sugar
import           Sibtek.DB.API
import           Sibtek.Model


data SQLite = SQLite

instance DBAPI SQLite where
  type DBConnectRequest   SQLite = FilePath
  type DBConnectionType   SQLite = DB.Connection
  type DBTableCreatorType SQLite = Text
  type DBToTableCreator   SQLite = ToCreateTableSQL

  dbConnect SQLite = DB.open • fmap DBConnection
  dbDisconnect (DBConnection conn) = DB.close conn

  getTableCreator SQLite (ModelIdentity ∷ ModelIdentity m) = DBTableCreator [qmb|
    -- {symbolVal (Proxy ∷ Proxy (ModelName m))}
    CREATE TABLE "{symbolVal (Proxy ∷ Proxy (DBTableName m))}" (
      {serializeFields ToCreateTableSQL (Proxy ∷ Proxy (FieldsSpec m))}
    );
  |]


class ToDBType t where toDBType ∷ Proxy t → Text
instance ToDBType Text where toDBType Proxy = "TEXT"
instance ToDBType Int  where toDBType Proxy = "INTEGER"


data ToCreateTableSQL = ToCreateTableSQL

instance (ToDBType t, Typeable t, KnownSymbol n, KnownSymbol d)
  ⇒ SerializeFields ToCreateTableSQL (ModelField n t d m)
  where
  type SerializeFieldsType ToCreateTableSQL = Text

  serializeFields ToCreateTableSQL Proxy =
    [qm| "{symbolVal (Proxy ∷ Proxy d)}" {toDBType (Proxy ∷ Proxy t)} |]

instance (SerializeFields ToCreateTableSQL a, SerializeFields ToCreateTableSQL b)
  ⇒ SerializeFields ToCreateTableSQL (a ⊳ b)
  where
  type SerializeFieldsType ToCreateTableSQL = Text

  serializeFields ToCreateTableSQL Proxy
    = serializeFields ToCreateTableSQL (Proxy ∷ Proxy a)
    ⋄ ",\n"
    ⋄ serializeFields ToCreateTableSQL (Proxy ∷ Proxy b)
