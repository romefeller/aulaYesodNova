{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}
{-# LANGUAGE TemplateHaskell   #-}
module Home where

import Foundation
import Yesod
import Text.Julius

getHomeR :: Handler Html
getHomeR = defaultLayout $ do
    setTitle "Minimal Multifile"
    toWidget $(juliusFile "templates/Cliente.julius")
    toWidget [julius|
       var node = document.getElementById('elm-cli');
       var app = Elm.Cliente.embed(node);
    |]
    [whamlet|
        <div id="elm-cli">
            
    |]
