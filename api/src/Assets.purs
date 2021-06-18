module Assets (handle, indexHtml) where

import Prelude

import Data.Either (Either(..), either)
import Data.Maybe (Maybe(..))
import Data.Array as Array

import Text.Parsing.Parser (ParseError, runParser)
import URI.Path as Path
import URI.Path.Segment (segmentFromString, unsafeSegmentFromString)

import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Console as Console

import Node.Globals as Global
import Node.FS.Aff as File

import HTTPure as Http

handle :: Http.Request -> Aff (Maybe Http.Response)
handle req = either logError getAsset paths
  where
    logError e = do
                   liftEffect $ Console.error $ show e
                   pure Nothing
    getAsset paths' = do
                        let reqPath = paths'.www <> Path.Path (req.path <#> unsafeSegmentFromString)
                        Http.notFound <#> Just

parsePath :: String -> Either ParseError Path.Path
parsePath s = runParser s Path.parser

paths :: Either ParseError {dir :: Path.Path, www :: Path.Path}
paths = do
          Path.Path dirnameSegments <- parsePath Global.__dirname -- /api/dist
          let dir = Path.Path (Array.dropEnd 1 dirnameSegments)   -- /api
          let www = dir <> Path.Path [(segmentFromString "www")]  -- /api/www
          pure {dir, www}

indexHtml :: Aff String
indexHtml = pure "foo"
