# backend

### An example of a model declaration that has a parent model

```haskell
import Data.Maybe (type Maybe)
import Data.Text (type Text)
import Data.Proxy
import Model.Class
import Model.FieldsBuilder


type FooModelSpec
   = IdentityField
   ⊳ ModelField "foo" Text         "foo_db_field"
   ⊳ ModelField "bar" (Maybe Text) "bar_db_field"

$(buildModelDataType "FooModel" (Proxy ∷ Proxy FooModelSpec))

instance Model FooModel where
  type DBTableName FooModel = "foo_db_tablename"
  type FieldsSpec  FooModel = FooModelSpec


type BarModelParent = FooModel

type BarModelSpec
  = ExtendFieldsSpec (FieldsSpec BarModelParent)
  ( ModelField "baz" Text "baz_db_field"
  ⊳ ModelField "bzz" Text "bzz_db_field"
  )

$(buildModelDataType "BarModel" (Proxy ∷ Proxy BarModelSpec))

instance Model BarModel where
  type DBTableName BarModel = "users"
  type Parent      BarModel = 'Just BarModelParent
  type FieldsSpec  BarModel = BarModelSpec
  parentModel = ParentModel ModelIdentity
```
