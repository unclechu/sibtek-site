-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Main (main) where

import           Servant ( Application
                         , Proxy (Proxy)
                         , Server
                         , serveWithContext
                         )

import           Network.Wai.Handler.Warp (run)

import qualified Data.Text as T
import           Data.IORef (IORef, newIORef)

import           Sibtek.Sugar
import           Sibtek.Handlers (SharedData (..), getServers)
import           Sibtek.Auth (AuthUser, authServerContext)
import           Sibtek.Routes (MainAPI)

import           Sibtek.Model.Class
import           Sibtek.Model.User
import           Sibtek.DB.API
import           Sibtek.DB.SQLite


getApp ∷ Server MainAPI → Application
getApp = serveWithContext (Proxy ∷ Proxy MainAPI) authServerContext

main ∷ IO ()
main = do

  let f p = T.intercalate "\n" $ map ("    " `T.append`) $ T.split (≡ '\n') $ modelFieldsSpecShow p

  putStrLn [qmb| \n
                 User model:
                 \  Model name: {modelName (ModelIdentity ∷ ModelIdentity UserModel)}
                 \  Table name: {symbolVal (Proxy ∷ Proxy (DBTableName UserModel))}
                 \  Fields:\n{f (Proxy ∷ Proxy (FieldsSpec UserModel))}
                 \n |]

  conn ← dbConnect SQLite "foo.db"
  dbDisconnect conn

  (authTokensStorage ∷ IORef [AuthUser]) ← newIORef []

  putStrLn [qm| Starting web server on {port} port… |]

  run port $ getApp $ getServers SharedData
    { authTokensStorage = authTokensStorage
    }

  where port = 8081
