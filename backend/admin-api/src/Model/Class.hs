-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

{-# LANGUAGE UndecidableInstances #-}

module Model.Class
     ( module Model.Class.Type
     , module Model.Class.Fields
     , module Model.Class.FieldsBuilder
     , type GetParentModel
     ) where

-- local imports
import           Model.Class.Type
import           Model.Class.Fields
import           Model.Class.FieldsBuilder


type family GetParentModel m where
  GetParentModel m = ExtractParentModel (Parent m)

type family ExtractParentModel (p ∷ Maybe *) where
  ExtractParentModel ('Just x) = x
