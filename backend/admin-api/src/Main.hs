-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Main (main) where

import           GHC.TypeLits

import           Servant ( Application
                         , Proxy (Proxy)
                         , Server
                         , serveWithContext
                         )

import           Network.Wai.Handler.Warp (run)

import qualified Database.PostgreSQL.Simple as PG

import qualified Data.Text as T
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

  let f p = T.intercalate "\n" $ map ("    " `T.append`) $ T.split (≡ '\n') $ modelFieldsSpecShow p

  putStrLn [qmb| \n
                 User model:
                 \  Model name: {modelName (undefined ∷ UserModel)}
                 \  Table name: {symbolVal (Proxy ∷ Proxy (DBTableName UserModel))}
                 \  Parent model name: \
                      {modelName (undefined ∷ GetParentModel UserModel)}
                 \  Parent table name: \
                      {symbolVal (Proxy ∷ Proxy (DBTableName (GetParentModel UserModel)))}
                 \  Fields:\n{f (Proxy ∷ Proxy (FieldsSpec UserModel))}

                 TestParentModel:
                 \  Model name: {modelName (undefined ∷ TestParentModel)}
                 \  Table name: {symbolVal (Proxy ∷ Proxy (DBTableName TestParentModel))}
                 \  Fields:\n{f (Proxy ∷ Proxy (FieldsSpec TestParentModel))}
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
