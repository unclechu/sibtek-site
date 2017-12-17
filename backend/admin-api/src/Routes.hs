-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Routes
  ( MainAPI
  , AuthAPI
  , UserRequest (..)
  , UserPassRequest (..)
  ) where

import           Servant (Get, Post, JSON, NoContent, ReqBody)
import           Data.Aeson (FromJSON, parseJSON, genericParseJSON, defaultOptions, Value (Object))

-- local
import           Sugar
import           Auth (AuthRequired)
import           Responses (SignInResponse, GetPublicSaltResponse)


type MainAPI = "admin" ‣ "api" ‣ "account" ‣ AuthAPI

type AuthAPI
  = "sign-in"         ‣ Get '[JSON] SignInResponse
  ‡ "sign-out"        ‣ AuthRequired ‣ Get '[JSON] NoContent
  ‡ "sign-up"         ‣ AuthRequired ‣ Get '[JSON] NoContent

  ‡ "get-public-salt" ‣ ReqBody '[JSON] UserRequest
                      ‣ Post '[JSON] GetPublicSaltResponse


data UserRequest
  = UserRequest String
    deriving (Eq, Show, Generic)

instance FromJSON UserRequest where
  parseJSON (Object x) = UserRequest <$> x ∴ "username"
  parseJSON x = genericParseJSON defaultOptions x


data UserPassRequest
  = UserPassRequest
  { username ∷ String
  , password ∷ String
  } deriving (Eq, Show, Generic)

instance FromJSON UserPassRequest
