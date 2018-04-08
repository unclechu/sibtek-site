-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

{-# LANGUAGE UndecidableInstances #-}

module Sibtek.Model.Class
     ( module Sibtek.Model.Class.Type
     , module Sibtek.Model.Class.Fields
     , module Sibtek.Model.Class.FieldsBuilder
     , type GetParentModel
     ) where

import           Sibtek.Model.Class.Type
import           Sibtek.Model.Class.Fields
import           Sibtek.Model.Class.FieldsBuilder


type family GetParentModel m where
  GetParentModel m = ExtractParentModel (Parent m)

type family ExtractParentModel (p ∷ Maybe *) where
  ExtractParentModel ('Just x) = x
