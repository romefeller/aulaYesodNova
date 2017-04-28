{-# LANGUAGE OverloadedStrings          #-}
import Application () -- for YesodDispatch instance
import Foundation
import Yesod
import Control.Monad.Logger (runStdoutLoggingT)
import Database.Persist.Postgresql
import Data.Text
import Data.Text.Encoding

connStr :: Text
connStr = "dbname=d41edljqvq29s3 host=ec2-107-21-223-72.compute-1.amazonaws.com user=lzmgovjvibjjnf password=E_kj4Kn5vzVleMxgtFEwDCP4cV port=5432"

main :: IO ()
main = runStdoutLoggingT $ withPostgresqlPool (encodeUtf8 connStr) 10 $ \pool -> liftIO $ do
    runSqlPersistMPool (runMigration migrateAll) pool 
    warp 8080 (App pool)
