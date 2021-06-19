module Assets (handle, indexHtml) where

import Prelude

import Data.String (Pattern(..), stripSuffix)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..), isJust, maybe)
import Data.Array as Array

import Text.Parsing.Parser (ParseError, runParser)
import URI.Path as Path
import URI.Path.Segment (segmentFromString)

import Effect.Aff (Aff)

import Node.Globals as Global
import Node.FS.Aff as File
import Node.Encoding (Encoding(UTF8))

import HTTPure as Http

import Partial.Unsafe (unsafePartial)

data FileType = Js | Css | Html

getFileType :: String -> Maybe FileType
getFileType fileName | stripSuffix (Pattern ".js"  ) fileName # isJust = Just Js
getFileType fileName | stripSuffix (Pattern ".css" ) fileName # isJust = Just Css
getFileType fileName | stripSuffix (Pattern ".html") fileName # isJust = Just Html
getFileType fileName = Nothing

mimeType :: FileType -> String
mimeType Js   = "application/js"
mimeType Css  = "text/css"
mimeType Html = "text/html"

handle :: Http.Request -> Aff (Maybe Http.Response)
handle req = do -- aff
               dir <- File.readdir $ Path.print paths.www

               -- Get the response to send if the following qs are all YES:
               --   * does the request path refer to a file in www?
               --   * do we support the file type? (Should always be yes)
               let resp = do -- maybe
                            file     <- Array.head req.path
                            fileType <- getFileType file
                            let mime = mimeType fileType

                            if Array.elem file dir then
                              Just do
                                let headers = Http.header "Content-Type" mime
                                buf  <- File.readFile $ Path.print (paths.www <> segmentToPath file)
                                Http.ok' headers buf
                            else
                              Nothing

               -- Maybe (Aff Http.Response) -> Aff (Maybe Http.Response)
               maybe (pure Nothing) (map Just) resp

parsePath :: String -> Either ParseError Path.Path
parsePath s = runParser s Path.parser

segmentToPath :: String -> Path.Path
segmentToPath = segmentFromString >>> Array.singleton >>> Path.Path

paths :: {dir :: Path.Path, www :: Path.Path}
paths = unsafePartial $ case paths' of -- This error will be more or less static and unlikely to fail
                          Right p -> p
  where
    paths' = do
               Path.Path dirnameSegments <- parsePath Global.__dirname -- /api/dist
               let dir = Path.Path (Array.dropEnd 1 dirnameSegments)   -- /api
               let www = dir <> (segmentToPath "www")                  -- /api/www
               pure {dir, www}

indexHtml :: Aff String
indexHtml = File.readTextFile UTF8 path
  where path = (paths.www <> segmentToPath "index.html") # Path.print
