defmodule OincWeb.Router do
  use OincWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {OincWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug, schema: OincWeb.Bank.Schema

    # coveralls-ignore-start
    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: OincWeb.Bank.Schema,
      socket: OincWeb.Bank.BankSocket,
      interface: :simple

    # coveralls-ignore-stop
  end

  # Other scopes may use custom stacks.
  # scope "/api", OincWeb do
  #   pipe_through :api
  # end
end
