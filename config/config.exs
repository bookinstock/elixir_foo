import Config

config :foo, env_foo: "new Foo"

config :foo, a: 1
config :foo, b: 2
config :foo, c: 3

import_config "foooo.exs"
