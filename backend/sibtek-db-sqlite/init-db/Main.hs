-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Main (main) where

import           System.Console.GetOpt
import           System.Environment (getArgs)

import qualified Data.Text as T
import qualified Data.Text.IO as T
import qualified Data.Map as Map
import qualified Data.Set as Set

import           Sibtek.Sugar
import           Sibtek.DB.API
import           Sibtek.DB.SQLite
import           Sibtek.Model


data Action = ShowQuery

data Options = Options
  { actionArg ∷ Maybe Action
  , modelsArg ∷ Maybe (Set.Set T.Text)
  }

defaultOptions ∷ Options
defaultOptions = Options
  { actionArg = Nothing
  , modelsArg = Nothing
  }

options ∷ [OptDescr (Options → Options)]
options =
  [ Option ['q'] ["show-query"]
      (NoArg (\opts → opts { actionArg = Just ShowQuery }))
      "Just print table creation SQL query to stdout"
  ]


main ∷ IO ()
main = do
  Options {..} ←
    getArgs >>= \args → getOpt Permute options args &
      \case (o, (fmap T.pack → Set.fromList → models), []) → pure $
              let opts = foldl (\x f → f x) defaultOptions o
               in Set.null models ? opts $ opts & \x → x { modelsArg = Just models }

            (_, _, errs) → ioError $ userError $ concat errs ⋄ showUsage

  !action ← maybe (ioError $ userError [qm| Please choose action!\n{showUsage} |]) pure actionArg

  !creatorsMap ← do
    let x = modelMap $ getTableCreator SQLite

    case modelsArg of
         Nothing → pure x
         Just l  → do
           let y = Map.restrictKeys x l
               unknown = Set.filter (flip Map.notMember y) l

           when (not $ Set.null unknown) $
             ioError $ let models = foldl (\acc x → [qm| {acc}\n  {x} |]) "" unknown
                        in userError [qm| Unknown models:{models ∷ String}\n{showUsage} |]

           pure y

  T.putStrLn $
    let creators = foldl (\acc x → [qm| {acc}\n{unwrapDBTableCreator x}\n |]) "" creatorsMap
     in [qm| BEGIN TRANSACTION;\n{creators ∷ String}\nCOMMIT; |]

  where showUsage = usageInfo "Usage: sibtek-init-db [OPTION…] [SPECIFIC-MODELS…]" options


modelMap ∷ ∀ a . (∀ m . SQLiteModel m ⇒ ModelIdentity m → a) → Map.Map T.Text a
modelMap mapFn = modelMap'
  where
    mapModel ∷ ∀ m . SQLiteModel m ⇒ ModelIdentity m → (T.Text, a)
    mapModel model = (T.pack $ symbolVal (Proxy ∷ Proxy (ModelName m)), mapFn model)
    modelMap' = Map.fromList $ mapModels mapModel (Proxy ∷ Proxy Models)


class TraverseModels a where
  mapModels ∷ ∀ b . (∀ m . SQLiteModel m ⇒ ModelIdentity m → b) → Proxy a → [b]

instance TraverseModels '[] where
  mapModels mapFn Proxy = []

instance (SQLiteModel m, TraverseModels xs) ⇒ TraverseModels (m ': xs) where
  mapModels mapFn Proxy =
    mapFn (ModelIdentity ∷ ModelIdentity m) : mapModels mapFn (Proxy ∷ Proxy xs)
