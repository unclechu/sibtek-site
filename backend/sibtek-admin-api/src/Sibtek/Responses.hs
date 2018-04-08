-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Sibtek.Responses
     ( SignInResponse (..)
     , GetPublicSaltResponse (..)
     ) where

import           Data.Aeson (ToJSON, toJSON)

import           Sibtek.Sugar


instance ToJSON SignInResponse where toJSON = myToJSON
data SignInResponse
  = SignInSuccess { publicToken ∷ String }
  | SignInFailure
  deriving (Eq, Show, Generic)


instance ToJSON GetPublicSaltResponse where toJSON = myToJSON
data GetPublicSaltResponse
  = GetPublicSaltSuccess { publicSalt ∷ String }
  | GetPublicSaltFailure
  deriving (Eq, Show, Generic)
