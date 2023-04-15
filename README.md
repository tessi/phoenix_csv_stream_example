# CsvStream

This is an example app to demonstrate streaming CSV data from the database to a CSV download.

* Streaming the data keeps the memory footprint of the phoenix app low
* The HTTP connection is kept open because data continously flows to the client
* It's efficient because we make postgres generate the CSV for us
* and if the request client (e.g. browser) accepts gzip-compression, the response is compressed on-the-fly

## Setup

  * Run `mix setup` to install and setup dependencies
  * Run `iex -S mix phx.server` and run `:observer.start()` to measure memory usage
  * Open `http://localhost:4000/api/users.csv` and observe memory NOT spiking :)
  * In another terminal, run `curl http://localhost:4000/api/users.csv |> /dev/null` to test the download

## Observations

Downloading the 294MB CSV takes ~3s while memory usage of the phoenix app stays flat.
Average download speed is 33M/s (compressed) or 91M/s (uncompressed) on my machine.

```
❯ curl --compressed http://localhost:4000/api/users.csv |> users.csv
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  134M    0  134M    0     0  32.6M      0 --:--:--  0:00:04 --:--:-- 33.5M

❯ curl http://localhost:4000/api/users.csv |> users.csv
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  294M    0  294M    0     0  91.4M      0 --:--:--  0:00:03 --:--:-- 91.6M
```

It's not super beautiful code -- all code is implemented in the controller `lib/csv_stream_web/controllers/user_controller.ex`.
Upside is, that it's easy to see what the code does in one spot :)

## Hat tips 🎩 

* [Great blog post about a performant way to stream CSV from postgres](https://joaquimadraz.com/csv-export-with-postgres-ecto-and-phoenix)
* [Great library to ZIP content streams](https://github.com/ne-sachirou/stream_gzip)
