module Handler.Pages where

import Import
import Text.Hamlet (hamletFile)
import Yesod.Markdown

readMarkdownFile :: String -> Handler Html
readMarkdownFile fp =
  defaultLayout $
  do x <- lift $ fmap markdownToHtmlTrusted (markdownFromFile fp)
     toWidget x

getRootR :: Handler Html
getRootR = readMarkdownFile "pages/root.md"

getAboutR :: Handler Html
getAboutR = readMarkdownFile "pages/about.md"

getJSPolicyR :: Handler Html
getJSPolicyR = readMarkdownFile "pages/js-policy.md"

getLinksR :: Handler Html
getLinksR =
  do let links = $(hamletFile "templates/links.hamlet")
     defaultLayout $
       do [whamlet|
           <ul>
             ^{links}
          |]
