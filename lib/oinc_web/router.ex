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

    forward "/graphql", Absinthe.Plug, schema: OincWeb.GraphqlBank.Schema

    # coveralls-ignore-start
    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: OincWeb.GraphqlBank.Schema,
      socket: OincWeb.GraphqlBank.BankSocket,
      interface: :simple

    # coveralls-ignore-stop
  end

  scope "/", OincWeb do
    pipe_through :browser

    live "/", Live.Bank, :index
    live "/clients", Live.Bank.Clients, :index
    live "/clients/new", Live.Bank.Clients, :new
    live "/clients/:id/address", Live.Bank.Clients, :address
  end

  # Other scopes may use custom stacks.
  # scope "/api", OincWeb do
  #   pipe_through :api
  # end
end
