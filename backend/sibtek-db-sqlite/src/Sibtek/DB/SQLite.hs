-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE UndecidableInstances #-}

module Sibtek.DB.SQLite
     ( SQLite (SQLite)
     , type SQLiteModel -- Complex constraint
     ) where

import           Data.Kind (type Constraint)
import           Data.Text (type Text)
import           Data.Typeable (type Typeable)
import           Data.Word (type Word)
import           Data.Maybe (isJust)

import qualified Database.SQLite.Simple as DB

import           Sibtek.Sugar
import           Sibtek.DB.API
import           Sibtek.Model


type family SQLiteModel m ∷ Constraint where
  SQLiteModel m
    = ( Model m
      , SerializeFields ToCreateTableSQL (FieldsSpec m)
      , SerializeFields ToCreateTableSQLConstraints (FieldsSpec m)
      )


data SQLite = SQLite

instance DBAPI SQLite where
  type DBConnectRequest            SQLite = FilePath
  type DBConnectionType            SQLite = DB.Connection
  type DBTableCreatorType          SQLite = Text
  type DBToTableCreatorSerializers SQLite = '[ToCreateTableSQL, ToCreateTableSQLConstraints]

  dbConnect SQLite = DB.open • fmap DBConnection
  dbDisconnect (DBConnection conn) = DB.close conn

  getTableCreator SQLite (ModelIdentity ∷ ModelIdentity m) = DBTableCreator [qmb|
    -- {symbolVal (Proxy ∷ Proxy (ModelName m))}
    CREATE TABLE "{symbolVal (Proxy ∷ Proxy (DBTableName m))}" (
      {serializeFields ToCreateTableSQL (Proxy ∷ Proxy (FieldsSpec m))}\
      { maybe "" (",\n" ⋄)
      $ serializeFields ToCreateTableSQLConstraints (Proxy ∷ Proxy (FieldsSpec m))
      }
    );
  |]


-- Converting haskell types to SQLite

class    ToDBType (t ∷ *) where toDBType ∷ Proxy t → Text
instance ToDBType Bool    where toDBType Proxy = "BOOLEAN"
instance ToDBType Text    where toDBType Proxy = "TEXT"
instance ToDBType Int     where toDBType Proxy = "INTEGER"
instance ToDBType Word    where toDBType Proxy = "INTEGER"
instance ToDBType Float   where toDBType Proxy = "REAL"
instance ToDBType Double  where toDBType Proxy = "REAL"


-- Modifiers for a field

class    ToDBModifier (t ∷ ModelFieldMeta) where toDBModifier ∷ Proxy t → Maybe Text
instance ToDBModifier 'MetaPrimaryKey      where toDBModifier Proxy = Just "PRIMARY KEY"
instance ToDBModifier 'MetaAutoIncrement   where toDBModifier Proxy = Just "AUTOINCREMENT"
instance ToDBModifier 'MetaUnique          where toDBModifier Proxy = Nothing

-- Add `NOT NULL` if type isn't `Maybe a`
class AddModifier a where addFieldModifier ∷ Proxy a → Text
instance AddModifier '[] where addFieldModifier Proxy = ""

instance (ToDBModifier x, AddModifier xs) ⇒ AddModifier (x ': xs) where
  addFieldModifier Proxy =
    [qm| {maybe "" (" " ⋄) $ toDBModifier (Proxy ∷ Proxy x)}
         {addFieldModifier (Proxy ∷ Proxy xs)} |]


-- Declarations of fields

data ToCreateTableSQL = ToCreateTableSQL

instance ( ToDBType t, Typeable t
         , KnownSymbol n, KnownSymbol d
         , AddModifier meta
         ) ⇒ SerializeFields ToCreateTableSQL (ModelField n t d meta)
  where
  type SerializeFieldsType ToCreateTableSQL = Text

  serializeFields ToCreateTableSQL Proxy =
    [qms| \  "{symbolVal (Proxy ∷ Proxy d)}"
              {toDBType (Proxy ∷ Proxy t)}\
              {addFieldModifier (Proxy ∷ Proxy meta)} |]

instance ( SerializeFields ToCreateTableSQL a
         , SerializeFields ToCreateTableSQL b
         ) ⇒ SerializeFields ToCreateTableSQL (a ⊳ b)
  where
  type SerializeFieldsType ToCreateTableSQL = Text

  serializeFields ToCreateTableSQL Proxy =
    [qmb| {serializeFields ToCreateTableSQL (Proxy ∷ Proxy a)},
          {serializeFields ToCreateTableSQL (Proxy ∷ Proxy b)} |]


-- Traversing fields to get SQL CONSTRAINTs from fields meta

data ToCreateTableSQLConstraints = ToCreateTableSQLConstraints

instance ( KnownSymbol d
         , SerializeMetaConstraints meta
         ) ⇒ SerializeFields ToCreateTableSQLConstraints (ModelField n t d meta)
  where
  type SerializeFieldsType ToCreateTableSQLConstraints = Maybe Text

  serializeFields ToCreateTableSQLConstraints Proxy =
    serializeMetaConstraints (Proxy ∷ Proxy meta) <*> pure (symbolVal (Proxy ∷ Proxy d))

instance ( SerializeFields ToCreateTableSQLConstraints α
         , SerializeFields ToCreateTableSQLConstraints β
         ) ⇒ SerializeFields ToCreateTableSQLConstraints (α ⊳ β)
  where
  type SerializeFieldsType ToCreateTableSQLConstraints = Maybe Text

  serializeFields ToCreateTableSQLConstraints Proxy =
    if isJust a ∧ isJust b then (\a b → [qm| {a},\n{b} |]) <$> a <*> b else a <|> b
    where a = serializeFields ToCreateTableSQLConstraints (Proxy ∷ Proxy α)
          b = serializeFields ToCreateTableSQLConstraints (Proxy ∷ Proxy β)


-- Field's meta -> SQL CONSTRAINT

class SerializeMetaConstraints a where
  serializeMetaConstraints ∷ Proxy a → Maybe (String → Text)

instance SerializeMetaConstraints '[] where
  serializeMetaConstraints Proxy = Nothing

instance (ToDBConstraint x, SerializeMetaConstraints xs) ⇒ SerializeMetaConstraints (x ': xs) where
  serializeMetaConstraints Proxy =
    if isJust a ∧ isJust b then f <$> a <*> b else a <|> b

    where a = toDBConstraint (Proxy ∷ Proxy x) <&> (• ("  " ⋄)) -- Adding indentation
          b = serializeMetaConstraints (Proxy ∷ Proxy xs)

          f fieldNameToConstraint xsToConstraint fieldName =
            fieldNameToConstraint fieldName ⋄ ",\n" ⋄ xsToConstraint fieldName


-- Convert specific field's meta to a SQL CONSTRAINT

class ToDBConstraint (t ∷ ModelFieldMeta) where
  toDBConstraint ∷ Proxy t → Maybe (String → Text)

instance ToDBConstraint 'MetaPrimaryKey    where toDBConstraint Proxy = Nothing
instance ToDBConstraint 'MetaAutoIncrement where toDBConstraint Proxy = Nothing

instance ToDBConstraint 'MetaUnique where
  toDBConstraint Proxy = Just $ \x → [qm| CONSTRAINT "{x}_unique" UNIQUE ("{x}") |]
