defmodule CsvStreamWeb.Router do
  use CsvStreamWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CsvStreamWeb do
    pipe_through :api

    get "/users.csv", UserController, :index
  end
end
