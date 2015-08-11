module Handler.Account.New where

import Control.Monad.Except
import Import
import Model.User
import Yesod.Form.Bootstrap3

newAccountForm :: Html -> MForm Handler (FormResult (ExceptT [String] IO User), Widget)
newAccountForm extra = do
  (usernameRes, usernameView) <- mreq textField (bfs' "Username") Nothing
  (passwordRes, passwordView) <- mreq passwordField (bfs' "Password") Nothing
  (passwordConfirmRes, passwordConfirmView) <- mreq passwordField (bfs' "Password (confirm)")
                                                 Nothing
  (emailRes, emailView) <- mopt emailField (bfs' "Email address (optional)") Nothing
  (submitRes, submitView) <- mbootstrapSubmit ("Create account!" :: BootstrapSubmit Text)
  let userRes = mkUser <$> usernameRes <*> passwordRes <*> passwordConfirmRes <*> emailRes
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

getAccountNewR :: Handler Html
getAccountNewR = do
  (nafWidget, enctype) <- generateFormPost newAccountForm
  defaultLayout $ do
    [whamlet|
      <form method=post action=@{AccountNewR} enctype=#{enctype} role=form>
        ^{nafWidget}
    |]

postAccountNewR :: Handler Html
postAccountNewR = do
  ((resultingUser, nafWidget), enctype) <- runFormPost newAccountForm
  case resultingUser of
    FormMissing -> error "Form missing"
    FormFailure messages ->
      defaultLayout $
        [whamlet|
          <p>There were some errors with your input:
          <ul>
            $forall msg <- messages
              <li>#{msg}
          <form method=post action=@{AccountNewR} enctype=#{enctype} role=form>
            ^{nafWidget}

        |]
    FormSuccess user' -> do
      user'' <- liftIO (runExceptT user')
      case user'' of
        Left errs ->
          defaultLayout $
            [whamlet|
              <p>There were some errors with your input:
              <ul>
                $forall err <- errs
                  <li>#{err}
              <form method=post action=@{AccountNewR} enctype=#{enctype} role=form>
                ^{nafWidget}

            |]
        Right user''' -> do
          _ <- runDB $ insert user'''
          let unom = userIdent user'''
          defaultLayout $ do
            [whamlet|
              <p>
                Successfully created user #{unom}! You can go to
                <a href=@{UserR unom}>/user/#{unom}</a>
                and view stuff.
            |]
