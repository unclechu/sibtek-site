-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Main (main) where

import           Servant ( Application
                         , Proxy (Proxy)
                         , Server
                         , serveWithContext
                         )

import           Network.Wai.Handler.Warp (run)

import qualified Database.PostgreSQL.Simple as PG

import qualified Data.Text as T
import           Data.IORef (IORef, newIORef)

import           Sibtek.Sugar
import           Sibtek.Handlers (SharedData (..), getServers)
import           Sibtek.Auth (AuthUser, authServerContext)
import           Sibtek.Routes (MainAPI)

import           Sibtek.Model.Class
import           Sibtek.Model.User


getApp ∷ Server MainAPI → Application
getApp = serveWithContext (Proxy ∷ Proxy MainAPI) authServerContext

main ∷ IO ()
main = do

  putStrLn [qms| Opening PostgreSQL connection on
                 {PG.connectHost dbCfg}:{PG.connectPort dbCfg}… |]

  let f p = T.intercalate "\n" $ map ("    " `T.append`) $ T.split (≡ '\n') $ modelFieldsSpecShow p

  putStrLn [qmb| \n
                 User model:
                 \  Model name: {modelName (ModelIdentity ∷ ModelIdentity UserModel)}
                 \  Table name: {symbolVal (Proxy ∷ Proxy (DBTableName UserModel))}
                 \  Fields:\n{f (Proxy ∷ Proxy (FieldsSpec UserModel))}
                 \n |]

  (dbConn ∷ PG.Connection) ← PG.connect dbCfg
  dbConn `seq` return ()

  (authTokensStorage ∷ IORef [AuthUser]) ← newIORef []

  putStrLn [qm| Web server is starting on {port} port… |]
  run port $ getApp $ getServers SharedData
    { dbConn            = dbConn
    , authTokensStorage = authTokensStorage
    }

  where port = 8081

        dbCfg = PG.defaultConnectInfo { PG.connectUser     = "sibtekwebsite"
                                      , PG.connectPassword = "development"
                                      , PG.connectDatabase = "sibtekwebsite"
                                      }
