module Model.User where

import Control.Monad (replicateM)
import Control.Monad.Except hiding (replicateM)
import Crypto.BCrypt
import qualified Data.ByteString as B
import qualified Data.Text.Encoding as T
import Import hiding (replicateM)
import System.Random

mkUser :: Text                  -- ^Username
       -> Text                  -- ^Password
       -> Text                  -- ^Password confirmation
       -> Maybe Text            -- ^Email
       -> ExceptT [String] IO User
mkUser username password passwordConfirm maybeEmail = do
  (password', salt) <- hash' password
  if null errors
    then return (User username password' salt maybeEmail False)
    else throwError errors

  where
    errors = mconcat
               [ validateIdent username
               , validatePassword' password passwordConfirm
               , validateEmail maybeEmail
               ]
    validateIdent _ = mempty
    validatePassword' _ _ = mempty
    validateEmail _ = mempty

-- |Hash using bcrypt
hash' :: Text -> ExceptT [String] IO (ByteString, ByteString) -- ^> (passwordHashedSalted, salt)
hash' pwdTxt = do
  saltWords <- replicateM 64 (liftIO randomIO)
  let salt = B.pack saltWords
      pwdSalted = mappend (T.encodeUtf8 pwdTxt) salt
  pwdHashedSalted <- liftIO (hashPasswordUsingPolicy slowerBcryptHashingPolicy pwdSalted) >>=
                     \case
                       Nothing ->
                         throwError ["BCrypt returned nothing when hashing salted password"]
                       Just x -> return x
  return (pwdHashedSalted, salt)
