defmodule CsvStream.Repo do
  use Ecto.Repo,
    otp_app: :csv_stream,
    adapter: Ecto.Adapters.Postgres
end
