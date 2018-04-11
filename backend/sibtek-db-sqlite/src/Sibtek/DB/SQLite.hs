-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE UndecidableInstances #-}

module Sibtek.DB.SQLite
     ( SQLite (SQLite)
     , ToCreateTableSQL (ToCreateTableSQL)
     , type SQLiteModel
     ) where

import           GHC.Generics

import           Data.Kind (type Constraint)
import           Data.Text (type Text)
import qualified Data.Text as T
import           Data.Typeable (type Typeable)

import qualified Database.SQLite.Simple as DB

import           Sibtek.Sugar
import           Sibtek.DB.API
import           Sibtek.Model


type family SQLiteModel m ∷ Constraint where
  SQLiteModel m = (Model m, SerializeFields ToCreateTableSQL (FieldsSpec m))


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


class    ToDBType (t ∷ *) where toDBType ∷ Proxy t → Text
instance ToDBType Text    where toDBType Proxy = "TEXT"
instance ToDBType Int     where toDBType Proxy = "INTEGER"


class    ToDBModifier (t ∷ ModelFieldMeta) where toDBModifier ∷ Proxy t → Text
instance ToDBModifier MetaPrimaryKey       where toDBModifier Proxy = "PRIMARY KEY"

class AddModifier a where addFieldModifier ∷ Proxy a → Text
instance AddModifier '[] where addFieldModifier Proxy = ""

instance (ToDBModifier x, AddModifier xs) ⇒ AddModifier (x ': xs) where
  addFieldModifier Proxy = " " ⋄ toDBModifier (Proxy ∷ Proxy x)


data ToCreateTableSQL = ToCreateTableSQL

instance (ToDBType t, Typeable t, KnownSymbol n, KnownSymbol d, AddModifier meta)
  ⇒ SerializeFields ToCreateTableSQL (ModelField n t d meta)
  where
  type SerializeFieldsType ToCreateTableSQL = Text

  serializeFields ToCreateTableSQL Proxy =
    [qms| "{symbolVal (Proxy ∷ Proxy d)}"
           {toDBType (Proxy ∷ Proxy t)}\
           {addFieldModifier (Proxy ∷ Proxy meta)} |]

instance (SerializeFields ToCreateTableSQL a, SerializeFields ToCreateTableSQL b)
  ⇒ SerializeFields ToCreateTableSQL (a ⊳ b)
  where
  type SerializeFieldsType ToCreateTableSQL = Text

  serializeFields ToCreateTableSQL Proxy
    = serializeFields ToCreateTableSQL (Proxy ∷ Proxy a)
    ⋄ ",\n"
    ⋄ serializeFields ToCreateTableSQL (Proxy ∷ Proxy b)
