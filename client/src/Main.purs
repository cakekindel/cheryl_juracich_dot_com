module Main where

import Prelude

import Effect (Effect)

import Halogen as H
import Halogen.Component (Component)
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.VDom.Driver (runUI)

main :: Effect Unit
main = HA.runHalogenAff do
         body <- HA.awaitBody
         runUI component unit body

component :: forall query m. Component query Unit Unit m
component = H.mkComponent { initialState: \_ -> unit
                          , render: \_ -> HH.p_ [HH.text "hello"]
                          , eval: H.mkEval $ H.defaultEval
                          }
