{ name = "api"
, dependencies =
  [ "arrays"
  , "console"
  , "effect"
  , "aff"
  , "control"
  , "strings"
  , "httpure"
  , "maybe"
  , "either"
  , "uri"
  , "node-fs-aff"
  , "parsing"
  , "node-process"
  , "prelude"
  , "psci-support"
  ]
, packages = ../packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
