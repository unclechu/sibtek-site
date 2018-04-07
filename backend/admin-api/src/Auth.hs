-- Author: Viacheslav Lotsmanov
-- License: AGPLv3

module Auth
     ( AuthRequired
     , AuthUser (..)
     , authServerContext
     ) where

import           Servant ( Handler
                         , Context (EmptyContext)
                         , AuthProtect
                         , ServantErr (errBody)
                         , throwError
                         , err400
                         , err401
                         , err403
                         )

import           Servant.Server.Experimental.Auth (AuthHandler, AuthServerData, mkAuthHandler)
import           Network.Wai (Request, requestHeaders)

import           Control.Monad ((>=>))

import           Data.List (find)
import           Data.Either.Combinators (rightToMaybe)
import           Data.ByteString.Char8 (ByteString)
import qualified Data.ByteString.Char8 as BS
import qualified Data.ByteString.Base64 as Base64
import qualified Crypto.Hash.SHA256 as SHA256 (hash)

-- local
import           Sugar


data AuthData
  = AuthData
  { authPublicToken ∷ String
  , authSalt        ∷ String
  , authHash        ∷ String
  } deriving (Eq, Show)

data AuthUser
  = AuthUser
  { userPublicToken  ∷ String
  , userPrivateToken ∷ String
  , userName         ∷ String
  } deriving (Eq, Show)

type AuthRequired = AuthProtect "custom-token"
type instance AuthServerData (AuthProtect "custom-token") = AuthUser


{-
  Sign-in flow:
    1. Getting public salt by username from database
       Route: /admin/api/account/get-public-salt
       (to hash password later and send it encrypted instead of sending it as plain text);
    2. Getting **private** and **public** tokens by hash of salted password
       that is base64("PUBLIC_SALT.RANDOM_SALT.`sha256("PUBLIC_SALT.RANDOM_SALT.PLAIN_PASSWORD")`");
    3. Storing **private** token in `window.localStorage` and never show it as plain text to server
       but it supposed to be used as salt for hashed password to generate `Authorization` header
       for future requests;
    4. Storing **public** token in `window.localStorage` to use it as identifier for user,
       it supposed to be used to generate `Authorization` header for future requests;
    5. Done.
 -}

usersDB ∷ [ AuthUser ]
usersDB = [ AuthUser { userPublicToken  = hexStr $ SHA256.hash "public"
                     , userPrivateToken = hexStr $ SHA256.hash "private"
                     , userName         = "john"
                     }
          ]


authenticate ∷ AuthData → Handler AuthUser
authenticate authData = (find comparePublicToken usersDB >>= compareHash)
                        & maybeResponse response403

  where comparePublicToken ∷ AuthUser → Bool
        comparePublicToken user = authPublicToken authData ≡ userPublicToken user

        compareHash ∷ AuthUser → Maybe AuthUser
        compareHash = ifMaybe $ \user → hashToCheck user ≡ authHash authData

        hashToCheck ∷ AuthUser → String
        hashToCheck user = hexStr $ SHA256.hash $ BS.pack $
          authPublicToken authData ⧺ authSalt authData ⧺ userPrivateToken user

        response403 = err403 { errBody = "Incorrect authorization credentials" }


authHandler ∷ AuthHandler Request AuthUser
authHandler = mkAuthHandler (getHeader >=> extractAuthData >=> authenticate)

  where response400 = err400 { errBody = "Incorrect authorization header" }
        response401 = err401 { errBody = "Missing authorization header" }

        getHeader ∷ Request → Handler ByteString
        getHeader = requestHeaders
                  • lookup "Authorization"
                  • maybeResponse response401

        extractAuthData ∷ ByteString → Handler AuthData
        extractAuthData = (validHeader >=> decodeHeader >=> getAuthData)
                        • maybeResponse response400

        validHeader ∷ ByteString → Maybe ByteString
        validHeader = ifMaybe $ BS.isPrefixOf prefix

        decodeHeader ∷ ByteString → Maybe ByteString
        decodeHeader = BS.drop (BS.length prefix) • Base64.decode • rightToMaybe

        getAuthData ∷ ByteString → Maybe AuthData
        getAuthData = BS.split '.' • getHashes • fmap (\[a, b, c] → AuthData a b c)

        prefix = BS.pack "Custom "
        hexChars = BS.pack $ ['0'..'9'] ⧺ ['a'..'f']

        isHashCorrect ∷ ByteString → Bool
        isHashCorrect x = BS.length x ≡ 64 ∧ BS.all (`BS.elem` hexChars) x

        getHashes ∷ [ByteString] → Maybe [String]
        getHashes = ifMaybe (\x → length x ≡ 3 ∧ all isHashCorrect x) • (map • fmap) BS.unpack


authServerContext ∷ Context (AuthHandler Request AuthUser ': '[])
authServerContext = authHandler ∵ EmptyContext


maybeResponse ∷ ServantErr → Maybe a → Handler a
maybeResponse err = \case Nothing → throwError err
                          Just x  → return x
