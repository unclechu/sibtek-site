-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Main (main) where

import           Servant ( Application
                         , Proxy (Proxy)
                         , Server
                         , serveWithContext
                         )

import           Network.Wai.Handler.Warp (run)

import           System.Console.GetOpt
import           System.Environment (getArgs)

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


data Options = Options
  { dbFileArg ∷ Maybe FilePath
  }

defaultOptions ∷ Options
defaultOptions = Options
  { dbFileArg = Nothing
  }

options ∷ [OptDescr (Options → Options)]
options =
  [ Option [] ["db-file"]
      (ReqArg (\file opts → opts { dbFileArg = Just file }) "FILE")
      "SQLite database file path"
  ]


main ∷ IO ()
main = do
  Options {..} ←
    getArgs >>= \args → getOpt Permute options args &
      \case (o, [], []  ) → pure $ foldl (\x f → f x) defaultOptions o
            (_, _,  errs) → ioError $ userError $ concat errs ⋄ showUsage

  !dbFile ←
    maybe (ioError $ userError [qm| Database file is required!\n{showUsage} |]) pure $
      preserveM (≠ "") dbFileArg

  let f p = T.intercalate "\n" $ map ("    " `T.append`) $ T.split (≡ '\n') $ modelFieldsSpecShow p

  putStrLn [qmb| \n
                 User model:
                 \  Model name: {symbolVal (Proxy ∷ Proxy (ModelName UserModel))}
                 \  Table name: {symbolVal (Proxy ∷ Proxy (DBTableName UserModel))}
                 \  Fields:\n{f (Proxy ∷ Proxy (FieldsSpec UserModel))}
                 \n |]

  conn ← dbConnect SQLite dbFile
  (authTokensStorage ∷ IORef [AuthUser]) ← newIORef []

  putStrLn [qm| Starting web server on {port} port… |]

  run port $ getApp $ getServers SharedData
    { authTokensStorage = authTokensStorage
    , dbConnection = conn
    }

  where port = 8081
        showUsage = usageInfo "Usage: sibtek-admin-api [OPTION…]" options
