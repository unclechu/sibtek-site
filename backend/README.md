# backend

## About operators

Any unfamiliar operator you see you probably find in the
[Sugar module](sibtek-sugar/src/Sibtek/Sugar.hs).
Most of them is just unicode aliases or flipped versions of other operators
(e.g. `(<&>)` is flipped version of `(<$>)` like `(&)` is flipped version of `($)`, or consider
`(•)`, left-to-right composition, it is flipped version of `(∘)`, usual right-to-left composition).

`(⋄)` (`mappend` of `Monoid`) is used almost everywhere instead of `(⧺)`.

Consider `(?)` operator, probably familiar for you from other programming languages such as **C**,
`foo ? bar : baz` in **C** would be `foo ? bar $ baz` in **Haskell** here.

`(|?|)` is just flipped version of `Data.Bool.bool`, the purpuse of this is to create a function
that takes `Bool` and choses either left part for `True` or right part for `False`. If you remove
`?` symbol from this operator you get `(||)`, so the logic kinda similar, you take *a* **OR** *b*:

```haskell
main = do
  let hiMessageFn = "Hi, Johnny" |?| "Hi, stranger"
  putStr "What is your name? Enter: "
  isJo ← getLine <&> (≡ "John")
  putStrLn $ hiMessageFn isJo
```

### An example of a model declaration that has a parent model

```haskell
import Data.Maybe (type Maybe)
import Data.Text (type Text)
import Data.Proxy
import Model.Class
import Model.FieldsBuilder


type FooModelSpec
   = IdentityField
   ⊳ ModelField "foo" Text         "foo_db_field" '[]
   ⊳ ModelField "bar" (Maybe Text) "bar_db_field" '[]

$(buildModelDataType "FooModel" (Proxy ∷ Proxy FooModelSpec))

instance Model FooModel where
  type DBTableName FooModel = "foo_db_tablename"
  type FieldsSpec  FooModel = FooModelSpec


type BarModelParent = FooModel

type BarModelSpec
  = ExtendFieldsSpec (FieldsSpec BarModelParent)
  ( ModelField "baz" Text "baz_db_field" '[]
  ⊳ ModelField "bzz" Text "bzz_db_field" '[]
  )

$(buildModelDataType "BarModel" (Proxy ∷ Proxy BarModelSpec))

instance Model BarModel where
  type DBTableName BarModel = "users"
  type Parent      BarModel = 'Just BarModelParent
  type FieldsSpec  BarModel = BarModelSpec
  parentModel = ParentModel ModelIdentity
```
