-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Handlers
  ( server
  ) where

import System.IO (stderr, hPutStrLn)
import Servant (Handler, Server, NoContent(NoContent))
import Control.Monad.IO.Class (liftIO)

-- local
import Sugar
import Auth (AuthUser)
import Routes (MainAPI)
import Responses (SignInResponse(SignInSuccess))


server ∷ Server MainAPI
server = signInHandler
       ‡ signOutHandler
       ‡ signUpHandler


signInHandler ∷ Handler SignInResponse
signInHandler = do liftIO $ hPutStrLn stderr [qm| signing in… |]
                   return $ SignInSuccess "it supposed to be a generated public token"


signOutHandler ∷ AuthUser → Handler NoContent
signOutHandler _ = do liftIO $ hPutStrLn stderr [qm| signing out… |]
                      return NoContent


signUpHandler ∷ AuthUser → Handler NoContent
signUpHandler _ = do liftIO $ hPutStrLn stderr [qm| signing up… |]
                     return NoContent
