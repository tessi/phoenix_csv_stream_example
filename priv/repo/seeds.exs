alias CsvStream.Accounts.User

Faker.start()

user_count = 4_000_000
chunk_size = 10_000
user_age_range = 0..111
now = NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

1..user_count
|> Enum.chunk_every(chunk_size)
|> Enum.each(fn chunk ->
  chunk
  |> Enum.map(fn _ ->
    %{
      name: Faker.Person.name(),
      age: Enum.random(user_age_range),
      inserted_at: now,
      updated_at: now
    }
  end)
  |> then(&CsvStream.Repo.insert_all(User, &1))
end)
