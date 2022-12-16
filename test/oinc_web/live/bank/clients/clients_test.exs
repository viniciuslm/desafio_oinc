defmodule OincWeb.Live.Bank.ClientsTest do
  use OincWeb.ConnCase
  import Phoenix.LiveViewTest

  alias Oinc.Bank
  alias Oinc.Bank.Projections.Client

  setup %{conn: conn} do
    client_params = build(:client_params)
    {:ok, %Client{} = client} = Bank.create_client(client_params)

    {:ok, conn: conn, client: client}
  end

  test "load page", %{conn: conn, client: client} do
    {:ok, view, _html} = live(conn, Routes.bank_clients_path(conn, :index))

    assert view |> has_element?("[data-role=client-item][data-id=#{client.id}]")

    assert view
           |> has_element?(
             "[data-role=client-name][data-id=#{client.id}]",
             client.name
           )
  end
end
