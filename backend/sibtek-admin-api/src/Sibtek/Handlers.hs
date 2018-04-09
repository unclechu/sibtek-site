-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Sibtek.Handlers
     ( SharedData (..)
     , getServers
     ) where

import           System.IO (stderr, hPutStrLn)
import           Servant (Handler, Server, NoContent (NoContent))
import           Control.Monad.IO.Class (liftIO)

import           Data.IORef (IORef, readIORef, modifyIORef)

import           Sibtek.Sugar
import           Sibtek.DB.API
import           Sibtek.Auth (AuthUser (..))
import           Sibtek.Routes (MainAPI, UserRequest (UserRequest))

import           Sibtek.Responses ( SignInResponse (SignInSuccess)
                                  , GetPublicSaltResponse (GetPublicSaltSuccess)
                                  )

import           Sibtek.Model.User ()


data DBAPI db
  ⇒ SharedData db
  = SharedData
  { authTokensStorage ∷ IORef [AuthUser]
  , dbConnection ∷ DBConnection db (DBConnectionType db)
  }


getServers ∷ DBAPI db ⇒ SharedData db → Server MainAPI
getServers s = signInHandler  s
             ‡ signOutHandler s
             ‡ signUpHandler  s
             ‡ getPublicSalt  s


signInHandler ∷ DBAPI db ⇒ SharedData db → Handler SignInResponse
signInHandler SharedData { authTokensStorage = s } = do
  liftIO $ hPutStrLn stderr [qm| signing in… |]
  return $ SignInSuccess "TODO it supposed to be a generated public token"


-- TODO implement
signOutHandler ∷ DBAPI db ⇒ SharedData db → AuthUser → Handler NoContent
signOutHandler _ _ = do liftIO $ hPutStrLn stderr [qm| signing out… |]
                        return NoContent


-- TODO implement
signUpHandler ∷ DBAPI db ⇒ SharedData db → AuthUser → Handler NoContent
signUpHandler _ _ = do liftIO $ hPutStrLn stderr [qm| signing up… |]
                       return NoContent


getPublicSalt ∷ DBAPI db ⇒ SharedData db → UserRequest → Handler GetPublicSaltResponse
getPublicSalt _ (UserRequest username) = do
  liftIO $ hPutStrLn stderr [qm| getting public salt… |]
  liftIO $ putStrLn username
  return $ GetPublicSaltSuccess "TODO it supposed to be a public salt of a user's password got from db"
