defmodule OincWeb.Live.Bank.SubscriptioTest do
  use OincWeb.ConnCase
  import Phoenix.LiveViewTest

  alias Oinc.Bank
  alias Oinc.Bank.Projections.Client

  test "load page", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.bank_subscription_path(conn, :index))

    assert view |> has_element?("[data-role=items-empty]")

    client_params = build(:client_params)
    {:ok, %Client{} = client} = Bank.create_client(client_params)

    refute view |> has_element?("[data-role=items-empty]")

    assert view
           |> has_element?(
             "[data-role=client-name][data-id=#{client.id}]",
             client.name
           )
  end
end
