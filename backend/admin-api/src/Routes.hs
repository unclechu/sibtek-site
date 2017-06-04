-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Routes
  ( MainAPI
  , AuthAPI
  ) where

import Servant (Get, JSON, NoContent)

-- local
import Sugar
import Auth (AuthRequired)
import Responses (SignInResponse)


type MainAPI = "admin" ‣ "api" ‣ (AuthAPI)

type AuthAPI = "account" ‣ ( "signin"  ‣ Get '[JSON] SignInResponse
                           ‡ "signout" ‣ AuthRequired ‣ Get '[JSON] NoContent
                           ‡ "signup"  ‣ AuthRequired ‣ Get '[JSON] NoContent
                           )
