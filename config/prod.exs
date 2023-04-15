import Config

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.

# Do not print debug messages in production
config :logger, level: :warn

# Runtime production configuration, including reading
# of environment variables, is done on config/runtime.exs.

config :csv_stream, CsvStream.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "csv_stream_dev",
  pool_size: 10

config :csv_stream, CsvStreamWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  secret_key_base: "nxkXi49Tyu/Wk0XkbB8P1r2Q0oqSZS6lXQKc6C8UcaOql6YlPUS/EVCJCq5ceLTa",
  watchers: []
