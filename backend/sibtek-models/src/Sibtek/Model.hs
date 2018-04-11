-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Sibtek.Model
     ( module Sibtek.Model.Class
     , module Sibtek.Model.User
     , type Models
     ) where

import qualified Data.Map as Map
import qualified Data.Text as T

import           Sibtek.Sugar
import           Sibtek.Model.Class
import           Sibtek.Model.User


type Models =
  '[ UserModel
   ]
