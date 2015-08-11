module Handler.Pages where

import Data.FileEmbed
import qualified Data.Text.Lazy as T
import qualified Data.Text.Encoding as T
import Import
import Text.Hamlet (hamletFile)
import Text.Markdown

markdownString :: ByteString -> Handler Html
markdownString =
  defaultLayout . toWidget . markdown def . T.fromStrict . T.decodeUtf8

getRootR :: Handler Html
getRootR = markdownString ($(embedFile "pages/root.md"))

getAboutR :: Handler Html
getAboutR = markdownString ($(embedFile "pages/about.md"))

getJSPolicyR :: Handler Html
getJSPolicyR = markdownString ($(embedFile "pages/js-policy.md"))

getLinksR :: Handler Html
getLinksR =
  do let links = $(hamletFile "templates/links.hamlet")
     defaultLayout $
       do [whamlet|
           <ul>
             ^{links}
          |]
