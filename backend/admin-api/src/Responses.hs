-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Responses
  ( SignInResponse(..)
  ) where

import Data.Aeson (ToJSON, toJSON, (.=), object)

-- local
import Sugar


data SignInResponse = SignInSuccess { signInPublicToken ∷ String }
                    | SignInFailure
                      deriving (Eq, Show, Generic)

instance ToJSON SignInResponse where
  toJSON (SignInSuccess token) = object ["publicToken" .= token]
  toJSON SignInFailure = object []
