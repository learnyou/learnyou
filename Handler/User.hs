module Handler.User where

import Import

getUserR :: Text -> Handler Html
getUserR userIdent = 
  -- Look up the user
  runDB (getBy (UniqueUser userIdent)) >>=
  \case
    -- No such user, return 404
    Nothing -> notFound
    -- There is a user, format the page
    Just user -> defaultLayout $ do
      [whamlet|
        #{show user}
      |]

