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
module Foundation where

import Yesod
import Data.Text
import Database.Persist.Postgresql

data App = App
    {
        connPool       :: ConnectionPool
    }

mkYesodData "App" $(parseRoutesFile "routes")

share [mkPersist sqlSettings {mpsGenerateLenses = True}, mkMigrate "migrateAll"][persistLowerCase|
    Cliente
        nome Text
|]

instance Yesod App

instance YesodPersist App where
   type YesodPersistBackend App = SqlBackend
   runDB f = do
       master <- getYesod
       let pool = connPool master
       runSqlPool f pool