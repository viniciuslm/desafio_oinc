defmodule OincWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.
  """

  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import OincWeb.ConnCase

      import Oinc.Factory

      alias OincWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint OincWeb.Endpoint
    end
  end

  setup tags do
    pid = Sandbox.start_owner!(Oinc.Repo, shared: not tags[:async])
    on_exit(fn -> Sandbox.stop_owner(pid) end)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
