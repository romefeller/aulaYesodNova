{-# LANGUAGE EmptyDataDecls             #-}
{-# LANGUAGE FlexibleContexts           #-}
{-# LANGUAGE GADTs                      #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE OverloadedStrings          #-}
{-# LANGUAGE QuasiQuotes                #-}
{-# LANGUAGE ViewPatterns               #-}
{-# LANGUAGE TemplateHaskell            #-}
{-# LANGUAGE TypeFamilies               #-}

module Cliente where

import Yesod
import Data.Text
import Database.Persist.Postgresql
import Foundation
import Network.HTTP.Types.Status

postClienteR :: Handler TypedContent
postClienteR = do
    cliente <- requireJsonBody :: Handler Cliente -- {"nome" : "andrew"}
    cid <- runDB $ insert cliente
    sendStatusJSON created201 (object ["resp" .= (fromSqlKey cid)])
    
getListClienteR :: Handler TypedContent
getListClienteR = do
    clientes <- runDB $ selectList [] [Asc ClienteNome]
    sendStatusJSON ok200 (object ["resp" .= clientes])
    
getBuscaR :: ClienteId -> Handler TypedContent
getBuscaR cid = do
    cliente <- runDB $ get404 cid -- selectList [ClienteId ==. cid] [Asc ClienteNome]
    sendStatusJSON ok200 (object ["resp" .= cliente])