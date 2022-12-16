defmodule OincWeb.Live.Bank.Accounts.CloseTest do
  use OincWeb.ConnCase
  import Phoenix.LiveViewTest

  alias Oinc.Bank
  alias Oinc.Bank.Projections.{Account, Client}

  setup %{conn: conn} do
    client_params = build(:client_params)
    {:ok, %Client{} = client} = Bank.create_client(client_params)

    open_account = build(:open_account_params, %{"client_id" => client.id})
    {:ok, %Account{} = account} = Bank.open_account(open_account)

    {:ok, conn: conn, account: account}
  end

  test "load modal open account", %{conn: conn, account: account} do
    {:ok, view, _html} = live(conn, Routes.bank_accounts_path(conn, :index))

    view
    |> element("[data-role=close-account]")
    |> render_click()

    assert view |> has_element?("#modal")
    assert view |> has_element?("[data-role=close-item-confirm][data-id=#{account.id}]")
    assert view |> has_element?("[data-role=close-item-cancel][data-id=#{account.id}]")

    {:ok, view, _html} =
      assert view
             |> element("[data-role=close-item-confirm][data-id=#{account.id}]")
             |> render_click()
             |> follow_redirect(conn, Routes.bank_accounts_path(conn, :index))

    refute view |> has_element?("[data-role=close-account][data-id=#{account.id}]")
  end
end
