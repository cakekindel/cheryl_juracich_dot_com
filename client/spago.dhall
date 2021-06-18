{ name = "client"
, dependencies =
  [ "console"
  , "effect"
  , "maybe"
  , "prelude"
  , "halogen"
  , "psci-support"
  ]
, packages = ../packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
