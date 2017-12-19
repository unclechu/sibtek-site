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

import           Data.IORef (IORef, newIORef)

-- local
import           Sugar
import           Handlers (SharedData (..), getServers)
import           Auth (AuthUser, authServerContext)
import           Routes (MainAPI)

import           Model.Class
import           Model.User


getApp ∷ Server MainAPI → Application
getApp = serveWithContext (Proxy ∷ Proxy MainAPI) authServerContext

main ∷ IO ()
main = do

  putStrLn [qms| Opening PostgreSQL connection on
                 {PG.connectHost dbCfg}:{PG.connectPort dbCfg}… |]

  putStrLn [qmb| \n
                 User model:
                 \  Model name: {modelName (modelInfo ∷ ModelInfo UserModel)}
                 \  Table name: {tableName (modelInfo ∷ ModelInfo UserModel)}
                 \  Parent model name: {parentModelName (modelInfo ∷ ModelInfo UserModel)}

                 TestParentModel:
                 \  Model name: {modelName (modelInfo ∷ ModelInfo TestParentModel)}
                 \  Table name: {tableName (modelInfo ∷ ModelInfo TestParentModel)}
                 \  Parent model name: \
                      {parentModelName (modelInfo ∷ ModelInfo TestParentModel)}
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
