module Handler.Login where

import Import
import Model.User

getLoginR :: Handler Html
getLoginR = do
  (widget, enctype) <- generateFormPost loginForm
  defaultLayout $ do
    [whamlet|
      <form method=post
            target=@{LoginR}
            enctype=#{enctype}
            role=form>
        ^{widget}
    |]

postLoginR :: Handler Html
postLoginR = do
  ((result, widget), enctype) <- runFormPost loginForm
  case result of
    FormMissing ->
      defaultLayout $ do
        [whamlet|
          <p>The form was missing. Please try again
          <form method=post
                target=@{LoginR}
                enctype=#{enctype}
                role=form>
            ^{widget}
        |]
    FormFailure errors ->
      defaultLayout $ do
        [whamlet|
          <p>There were some errors with the form data you submitted:
          <ul>
            $forall err <- errors
              <li>#{err}
          <form method=post
                target=@{LoginR}
                enctype=#{enctype}
                role=form>
            ^{widget}
        |]
    FormSuccess _ ->
      error "Not yet implemented: logging in."
      

