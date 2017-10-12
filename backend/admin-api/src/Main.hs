-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Main (main) where

import Servant ( Application
               , serveWithContext
               , Proxy (Proxy)
               )

import Network.Wai.Handler.Warp (run)

import qualified Database.PostgreSQL.Simple as PG
  ( connect
  , defaultConnectInfo
  , ConnectInfo (connectHost, connectPort, connectUser, connectPassword, connectDatabase)
  )

import qualified Data.ByteString.Char8 as BS

-- local
import Sugar
import Handlers (server)
import Auth (authServerContext)
import Routes (MainAPI)


app ∷ Application
app = serveWithContext (Proxy ∷ Proxy MainAPI) authServerContext server

main ∷ IO ()
main = do putStrLn [qm| Opening PostgreSQL connection on
                      \ {PG.connectHost dbCfg}:{PG.connectPort dbCfg}… |]

          dbConn ← PG.connect dbCfg
          dbConn `seq` return ()

          putStrLn [qm| Web server is starting on {port} port… |]
          run port app

  where port = 8081

        dbCfg = PG.defaultConnectInfo { PG.connectUser     = "sibtekwebsite"
                                      , PG.connectPassword = "development"
                                      , PG.connectDatabase = "sibtekwebsite"
                                      }
