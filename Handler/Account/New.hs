module Handler.Account.New where

import Control.Monad.Except
import Import
import Model.User

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
      user'' <- runExceptT user'
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
