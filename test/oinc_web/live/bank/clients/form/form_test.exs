defmodule OincWeb.Live.Bank.Clients.FormTest do
  use OincWeb.ConnCase
  import Phoenix.LiveViewTest

  test "load modal insert client", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.bank_clients_path(conn, :index))

    open_modal(view)

    assert has_element?(view, "[data-role=modal]")
    assert has_element?(view, "[data-role=client-form]")

    assert view |> form("#new", client: %{name: nil}) |> render_change() =~
             "can&#39;t be blank"
  end

  test "load modal and close modal", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.bank_clients_path(conn, :index))

    open_modal(view)

    assert view |> has_element?("#modal")
    assert view |> has_element?("#close")
  end

  test "give a client when submit the form then return a message that has created the client",
       %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.bank_clients_path(conn, :index))

    open_modal(view)

    payload = %{
      name: "teste client 2",
      cpf: "11111111111"
    }

    {:ok, _view, html} =
      view
      |> form("#new",
        client: payload
      )
      |> render_submit()
      |> follow_redirect(conn, Routes.bank_clients_path(conn, :index))

    assert html =~ "Client added!"
  end

  defp open_modal(view) do
    view
    |> element("[data-role=add-client]")
    |> render_click()
  end
end
