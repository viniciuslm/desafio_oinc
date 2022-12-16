defmodule OincWeb.Live.Bank.Address.FormTest do
  use OincWeb.ConnCase
  import Phoenix.LiveViewTest

  alias Oinc.Bank
  alias Oinc.Bank.Projections.Client

  setup %{conn: conn} do
    client_params = build(:client_params)
    {:ok, %Client{} = client} = Bank.create_client(client_params)

    {:ok, conn: conn, client: client}
  end

  test "load modal insert address", %{conn: conn, client: client} do
    {:ok, view, _html} = live(conn, Routes.bank_clients_path(conn, :index))

    open_modal(view, client.id)

    assert has_element?(view, "[data-role=modal]")
    assert has_element?(view, "[data-role=address-form]")

    assert view |> form("#address", address: %{city: nil}) |> render_change() =~
             "can&#39;t be blank"
  end

  test "load modal and close modal", %{conn: conn, client: client} do
    {:ok, view, _html} = live(conn, Routes.bank_clients_path(conn, :index))

    open_modal(view, client.id)

    assert view |> has_element?("#modal")
    assert view |> has_element?("#close")
  end

  test "give a address when submit the form then return a message that has created the address",
       %{conn: conn, client: client} do
    {:ok, view, _html} = live(conn, Routes.bank_clients_path(conn, :index))

    open_modal(view, client.id)

    payload = %{
      client_id: client.id,
      city: "city test",
      state: "state test"
    }

    {:ok, view, html} =
      view
      |> form("#address",
        address: payload
      )
      |> render_submit()
      |> follow_redirect(conn, Routes.bank_clients_path(conn, :index))

    assert html =~ "Address added!"

    refute has_element?(view, "[data-role=add-address][data-id=#{client.id}]")
  end

  defp open_modal(view, id) do
    view
    |> element("[data-role=add-address][data-id=#{id}]")
    |> render_click()
  end
end
