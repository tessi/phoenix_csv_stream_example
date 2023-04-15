defmodule CsvStream.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CsvStream.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        age: 42,
        name: "some name"
      })
      |> CsvStream.Accounts.create_user()

    user
  end
end
