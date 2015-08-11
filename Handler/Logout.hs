module Handler.Logout where

import Import

getLogoutR :: Handler Html
getLogoutR = defaultLayout $ do $(widgetFile "logout")

postLogoutR :: Handler Html
postLogoutR = error "Not yet implemented: postLogoutR"
