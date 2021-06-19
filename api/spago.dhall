{ name = "api"
, dependencies =
  [ "arrays"
  , "console"
  , "effect"
  , "aff"
  , "control"
  , "strings"
  , "partial"
  , "httpure"
  , "maybe"
  , "either"
  , "uri"
  , "parsing"
  , "node-fs-aff"
  , "node-process"
  , "node-buffer"
  , "prelude"
  , "psci-support"
  ]
, packages = ../packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
