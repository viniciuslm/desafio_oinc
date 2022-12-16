defmodule OincWeb.SubscriptionCase do
  use ExUnit.CaseTemplate

  alias Absinthe.Phoenix.SubscriptionTest

  using do
    quote do
      # Import conveniences for testing with channels
      import Phoenix.ChannelTest
      import OincWeb.ChannelCase

      use SubscriptionTest, schema: OincWeb.Graphql.Bank.Schema

      # The default endpoint for testing
      @endpoint OincWeb.Endpoint

      setup do
        {:ok, socket} = Phoenix.ChannelTest.connect(OincWeb.BankSocket, %{})
        {:ok, socket} = SubscriptionTest.join_absinthe(socket)

        {:ok, socket: socket}
      end
    end
  end
end
