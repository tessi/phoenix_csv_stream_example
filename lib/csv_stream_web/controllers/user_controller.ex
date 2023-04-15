defmodule CsvStreamWeb.UserController do
  use CsvStreamWeb, :controller

  action_fallback CsvStreamWeb.FallbackController

  alias CsvStream.Repo
  alias CsvStream.Accounts.User
  import Ecto.Query

  @chunk_size 1_000

  def index(conn, _params) do
    query =
      from user in User,
        select: [
          user.id,
          user.name,
          user.age,
          fragment(
            "to_char(? at time zone 'UTC', 'YYYY-MM-DD\"T\"HH24:MI:SS\"Z\"')",
            user.inserted_at
          )
        ]

    stream = build_users_csv_stream(query, compress_response?(conn))

    conn
    |> set_csv_headers("users.csv", compress_response?(conn))
    |> stream_csv(stream)
  end

  defp compress_response?(conn) do
    case get_req_header(conn, "accept-encoding") do
      [accept_encoding] -> String.contains?(accept_encoding, "gzip")
      _ -> false
    end
  end

  defp build_users_csv_stream(query, gzip_stream, batch_size \\ @chunk_size) do
    {sql, sql_params} = Repo.to_sql(:all, query)
    query = "COPY (#{sql}) to STDOUT WITH CSV DELIMITER ',';"
    csv_header = ["id,name,age,inserted_at\n"]

    Ecto.Adapters.SQL.stream(Repo, query, sql_params, max_rows: batch_size)
    |> Stream.map(& &1.rows)
    |> then(&Stream.concat(csv_header, &1))
    |> then(fn
      stream when gzip_stream -> StreamGzip.gzip(stream, level: :best_speed)
      stream -> stream
    end)
  end

  defp set_csv_headers(conn, filename, set_gzip_header) do
    conn
    |> put_resp_header("Content-Disposition", "attachment; filename=\"#{filename}\"")
    |> put_resp_header("Content-Type", "text/csv")
    |> then(fn
      conn when set_gzip_header -> put_resp_header(conn, "Content-Encoding", "gzip")
      _ -> conn
    end)
    |> send_chunked(200)
  end

  defp stream_csv(conn, stream) do
    {:ok, conn} =
      Repo.transaction(
        fn ->
          Enum.reduce_while(stream, conn, fn chunk, conn ->
            case Plug.Conn.chunk(conn, chunk) do
              {:ok, conn} -> {:cont, conn}
              {:error, :closed} -> {:halt, conn}
            end
          end)
        end,
        timeout: :infinity
      )

    conn
  end
end
