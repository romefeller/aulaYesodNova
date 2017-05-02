{-# LANGUAGE OverloadedStrings          #-}
import Application () -- for YesodDispatch instance
import Foundation
import Yesod
import Control.Monad.Logger (runStdoutLoggingT)
import Database.Persist.Postgresql
import Data.Text
import Data.Text.Encoding

connStr :: Text
connStr = "dbname=dd9en8l5q4hh2a host=ec2-107-21-219-201.compute-1.amazonaws.com user=kpuwtbqndoeyqb password=aCROh525uugAWF1l7kahlNN3E0 port=5432"

-- codenvy 3000
main :: IO ()
main = runStdoutLoggingT $ withPostgresqlPool (encodeUtf8 connStr) 10 $ \pool -> liftIO $ do
    runSqlPersistMPool (runMigration migrateAll) pool 
    warp 8080 (App pool)
