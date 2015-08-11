module Handler.Login where

import Import

getLoginR :: Handler Html
getLoginR = defaultLayout $ do $(widgetFile "login")

postLoginR :: Handler Html
postLoginR = error "Not yet implemented: postLoginR"
