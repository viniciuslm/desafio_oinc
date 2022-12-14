import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :oinc, Oinc.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "oinc_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# Configures the event store database
config :oinc, Oinc.EventStore,
  serializer: Commanded.Serialization.JsonSerializer,
  username: "postgres",
  password: "postgres",
  database: "oinc_eventstore_test",
  hostname: "localhost",
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :oinc, OincWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "nIVJaa0ECPl0Wv8F+krtdyZ4NdPVPT2X5yD2OWK7KC2ETi/c29Bz0ByCBeR5ZFyF",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
