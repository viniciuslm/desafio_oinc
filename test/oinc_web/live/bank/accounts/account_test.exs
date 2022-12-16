defmodule OincWeb.Live.Bank.AccountsTest do
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

  test "load page", %{conn: conn, account: account} do
    {:ok, view, _html} = live(conn, Routes.bank_accounts_path(conn, :index))

    assert view |> has_element?("[data-role=account-item][data-id=#{account.id}]")

    assert view
           |> has_element?(
             "[data-role=account-id][data-id=#{account.id}]",
             account.id
           )
  end
end
