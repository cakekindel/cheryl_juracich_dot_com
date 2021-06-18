module Main where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Array as Array

import Effect (Effect)
import Effect.Console as Console

import HTTPure as Http

helloWorld :: Http.Request -> Maybe Http.ResponseM
helloWorld {path: ["hello"], method: Http.Get} = Http.ok "Hello, world!" # Just
helloWorld _ = Nothing

app :: Http.Request -> Maybe Http.ResponseM
app req = helloWorld req

main :: Http.ServerM
main = Http.serve 8080 route logStarted

apiPrefix :: Http.Request -> Http.Request
apiPrefix req =
  let
    scrubPath path | Array.take 2 path == ["api", "v1"] = Array.drop 2 path
    scrubPath path = path
  in
    req {path = (scrubPath req.path)}

route :: Http.Request -> Http.ResponseM
route req = case app (apiPrefix req) of
              Just res -> res
              Nothing  -> Http.notFound

logStarted :: Effect Unit
logStarted = do
  Console.log "Server started"
