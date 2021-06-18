module Api where

import Prelude

import Data.Maybe (Maybe(..))

import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Console as Console

import HTTPure as Http

handle :: Http.Request -> Aff (Maybe Http.Response)
handle req = helloWorld req

helloWorld :: Http.Request -> Aff (Maybe Http.Response)
helloWorld {path: ["hello"], method: Http.Get} = Http.ok "Hello, world!" <#> Just
helloWorld _ = pure Nothing
