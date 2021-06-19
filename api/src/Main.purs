module Main where

import Prelude

import Data.Maybe (maybe')
import Data.String (trim, joinWith)
import Data.Array ((:))
import Data.Array as Array

import Control.Alternative ((<|>))

import Effect.Class (liftEffect)
import Effect.Console as Console

import HTTPure as Http

import Api as Api
import Assets as Assets

main :: Http.ServerM
main = Http.serve 8080 router logInit
  where logInit = Console.log "Server started, listening at localhost:8080"

router :: Http.Request -> Http.ResponseM
router req = do
               liftEffect $ Console.log $ logRequest req

               apiResponse    <- Api.handle apiReq
               assetsResponse <- Assets.handle req

               let maybeResp = apiResponse <|> assetsResponse
               let fallback = \_ -> Assets.indexHtml >>= Http.ok' (Http.header "content-type" "text/html")

               resp <- maybe' fallback pure maybeResp

               liftEffect $ Console.log $ logResponse req resp

               pure resp
  where
    scrubPath path | Array.take 2 path == ["api", "v1"] = Array.drop 2 path
    scrubPath path = path

    apiReq = req {path = scrubPath req.path}

logRequest :: Http.Request -> String
logRequest req = logRequest'
  where
    label = show req.method <> " " <> (joinWith "/" $ "" : req.path)
    logRequest' | trim req.body == "" = "-> " <> label
    logRequest' = "-> " <> label
               <> "Body:"
               <> "\n\n"
               <> req.body

logResponse :: Http.Request -> Http.Response -> String
logResponse req resp = "<- " <> label <> ": " <> show resp.status
  where
    label = show req.method <> " " <> (joinWith "/" $ "" : req.path)
