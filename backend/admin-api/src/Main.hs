-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Main (main) where

import Servant ( Application
               , serveWithContext
               , Proxy (Proxy)
               )

import Network.Wai.Handler.Warp (run)

-- local
import Sugar
import Handlers (server)
import Auth (authServerContext)
import Routes (MainAPI)


app ∷ Application
app = serveWithContext (Proxy ∷ Proxy MainAPI) authServerContext server

main ∷ IO ()
main = do putStrLn [qm| App is starting on {port} port… |]
          run port app

  where port = 8081
