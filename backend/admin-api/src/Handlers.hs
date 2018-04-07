-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Handlers
     ( SharedData (..)
     , getServers
     ) where

import           System.IO (stderr, hPutStrLn)
import           Servant (Handler, Server, NoContent (NoContent))
import           Control.Monad.IO.Class (liftIO)

import qualified Database.PostgreSQL.Simple as PG
import           Database.PostgreSQL.Simple.SqlQQ (sql)

import           Data.IORef (IORef, readIORef, modifyIORef)

-- local

import           Sugar
import           Auth (AuthUser (..))
import           Routes (MainAPI, UserRequest (UserRequest))

import           Responses ( SignInResponse (SignInSuccess)
                           , GetPublicSaltResponse (GetPublicSaltSuccess)
                           )

import           Model.User ()


data SharedData
  = SharedData
  { dbConn            ∷ PG.Connection
  , authTokensStorage ∷ IORef [AuthUser]
  }


getServers ∷ SharedData → Server MainAPI
getServers s = signInHandler  s
             ‡ signOutHandler s
             ‡ signUpHandler  s
             ‡ getPublicSalt  s


signInHandler ∷ SharedData → Handler SignInResponse
signInHandler SharedData { authTokensStorage = s } = do
  liftIO $ hPutStrLn stderr [qm| signing in… |]
  return $ SignInSuccess "TODO it supposed to be a generated public token"


-- TODO implement
signOutHandler ∷ SharedData → AuthUser → Handler NoContent
signOutHandler _ _ = do liftIO $ hPutStrLn stderr [qm| signing out… |]
                        return NoContent


-- TODO implement
signUpHandler ∷ SharedData → AuthUser → Handler NoContent
signUpHandler _ _ = do liftIO $ hPutStrLn stderr [qm| signing up… |]
                       return NoContent


getPublicSalt ∷ SharedData → UserRequest → Handler GetPublicSaltResponse
getPublicSalt _ (UserRequest username) = do
  liftIO $ hPutStrLn stderr [qm| getting public salt… |]
  liftIO $ putStrLn username
  return $ GetPublicSaltSuccess "TODO it supposed to be a public salt of a user's password got from db"
