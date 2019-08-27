import Config

config :foo, :x,
  log_level: :warn,
  adapter: Ecto.Adapters.Postgres

config :foo, :y,
  log_level: :info,
  pool_size: 10
