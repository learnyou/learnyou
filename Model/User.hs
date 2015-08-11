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
       -> ExceptT [String] Handler User
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
hash' :: Text
      -> ExceptT [String] Handler (ByteString, ByteString) -- ^> (passwordHashedSalted, salt)
hash' pwdTxt = do
  saltWords <- replicateM 64 (liftIO randomIO)
  let salt = B.pack saltWords
      pwdSalted = mappend (T.encodeUtf8 pwdTxt) salt
  pwdHashedSalted <-
    liftIO (hashPasswordUsingPolicy slowerBcryptHashingPolicy pwdSalted) >>=
    \case
      Nothing ->
        throwError ["BCrypt returned nothing when hashing salted password"]
      Just x -> return x
  return (pwdHashedSalted, salt)

loginForm :: Form (Text, Text)
loginForm =
  renderBootstrap3 BootstrapBasicForm $
    (,) <$> areq textField "Username" Nothing
        <*> areq passwordField "Password" Nothing
        <*  bootstrapSubmit ("Login" :: BootstrapSubmit Text)

newAccountForm :: Form (ExceptT [String] Handler User)
newAccountForm extra = do
  (usernameRes, usernameView) <- mreq textField (bfs' "Username") Nothing
  (passwordRes, passwordView) <- mreq passwordField (bfs' "Password") Nothing
  (passwordConfirmRes, passwordConfirmView) <- mreq passwordField (bfs' "Password (confirm)")
                                                 Nothing
  (emailRes, emailView) <- mopt emailField (bfs' "Email address (optional)") Nothing
  (submitRes, submitView) <- mbootstrapSubmit ("Create account!" :: BootstrapSubmit Text)
  let userRes = mkUser <$> usernameRes
                       <*> passwordRes
                       <*> passwordConfirmRes
                       <*> emailRes
                       <* submitRes
  let widget =
        [whamlet|
          #{extra}
          <div .form-group>
            <label>Username
            ^{fvInput usernameView}
          <div .form-group>
            <label>Password
            ^{fvInput passwordView}
          <div .form-group>
            <label>Password (confirm)
            ^{fvInput passwordConfirmView}
          <div .form-group>
            <label>Email (optional)
            ^{fvInput emailView}
          ^{fvInput submitView}
        |]
  return (userRes, widget)

  where
    bfs' :: Text -> FieldSettings site
    bfs' = bfs
