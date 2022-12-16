defmodule OincWeb.Live.Bank.Accounts.OpenTest do
  use OincWeb.ConnCase
  import Phoenix.LiveViewTest

  alias Oinc.Bank
  alias Oinc.Bank.Projections.Client

  setup %{conn: conn} do
    client_params = build(:client_params)
    {:ok, %Client{} = client} = Bank.create_client(client_params)

    {:ok, conn: conn, client: client}
  end

  test "load modal open account", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.bank_accounts_path(conn, :index))

    open_modal(view)

    assert has_element?(view, "[data-role=modal]")
    assert has_element?(view, "[data-role=open-account-form]")

    assert view |> form("#open", open_account: %{initial_balance: nil}) |> render_change() =~
             "can&#39;t be blank"
  end

  test "load modal and close modal", %{conn: conn} do
    {:ok, view, _html} = live(conn, Routes.bank_accounts_path(conn, :index))

    open_modal(view)

    assert view |> has_element?("#modal")
    assert view |> has_element?("#close")
  end

  test "give a account when submit the form then return a message that has opened the account",
       %{conn: conn, client: client} do
    {:ok, view, _html} = live(conn, Routes.bank_accounts_path(conn, :index))

    open_modal(view)

    payload = %{
      client_id: client.id,
      initial_balance: 100
    }

    {:ok, _view, html} =
      view
      |> form("#open",
        open_account: payload
      )
      |> render_submit()
      |> follow_redirect(conn, Routes.bank_accounts_path(conn, :index))

    assert html =~ "Account opened!"
  end

  test "give a initial_balance zero when submit the form then return an error",
       %{conn: conn, client: client} do
    {:ok, view, _html} = live(conn, Routes.bank_accounts_path(conn, :index))

    open_modal(view)

    payload = %{
      client_id: client.id,
      initial_balance: 0
    }

    view
    |> form("#open",
      open_account: payload
    )
    |> render_submit()

    assert has_element?(view, "[data-role=erro-message]", "Initial balance: must be above zero")
  end

  defp open_modal(view) do
    view
    |> element("[data-role=open-account]")
    |> render_click()
  end
end
