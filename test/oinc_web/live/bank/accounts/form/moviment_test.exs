defmodule OincWeb.Live.Bank.Accounts.MovimentTest do
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

  describe "deposit account" do
    test "load modal", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.bank_accounts_path(conn, :index))

      open_modal(view, "deposit")

      assert has_element?(view, "[data-role=modal]")
      assert has_element?(view, "[data-role=moviment-account-form]")

      assert view |> form("#deposit", moviment_account: %{amount: nil}) |> render_change() =~
               "can&#39;t be blank"
    end

    test "load modal and close modal", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.bank_accounts_path(conn, :index))

      open_modal(view, "deposit")

      assert view |> has_element?("#modal")
      assert view |> has_element?("#close")
    end

    test "give a account when submit the form then return a message that has deposited the account",
         %{conn: conn, account: account} do
      {:ok, view, _html} = live(conn, Routes.bank_accounts_path(conn, :index))

      open_modal(view, "deposit")

      payload = %{
        account_id: account.id,
        amount: 100
      }

      {:ok, _view, html} =
        view
        |> form("#deposit",
          moviment_account: payload
        )
        |> render_submit()
        |> follow_redirect(conn, Routes.bank_accounts_path(conn, :index))

      assert html =~ "Deposited account!"
    end

    test "give a amount zero when submit the form then return an error",
         %{conn: conn, account: account} do
      {:ok, view, _html} = live(conn, Routes.bank_accounts_path(conn, :index))

      open_modal(view, "deposit")

      payload = %{
        account_id: account.id,
        amount: 0
      }

      view
      |> form("#deposit",
        moviment_account: payload
      )
      |> render_submit()

      assert has_element?(view, "[data-role=erro-message]", "Amount: must be above zero")
    end
  end

  describe "withdrawn account" do
    test "load modal", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.bank_accounts_path(conn, :index))

      open_modal(view, "withdrawn")

      assert has_element?(view, "[data-role=modal]")
      assert has_element?(view, "[data-role=moviment-account-form]")

      assert view |> form("#withdrawn", moviment_account: %{amount: nil}) |> render_change() =~
               "can&#39;t be blank"
    end

    test "load modal and close modal", %{conn: conn} do
      {:ok, view, _html} = live(conn, Routes.bank_accounts_path(conn, :index))

      open_modal(view, "withdrawn")

      assert view |> has_element?("#modal")
      assert view |> has_element?("#close")
    end

    test "give a account when submit the form then return a message that has withdrawned the account",
         %{conn: conn, account: account} do
      {:ok, view, _html} = live(conn, Routes.bank_accounts_path(conn, :index))

      open_modal(view, "withdrawn")

      payload = %{
        account_id: account.id,
        amount: 100
      }

      {:ok, _view, html} =
        view
        |> form("#withdrawn",
          moviment_account: payload
        )
        |> render_submit()
        |> follow_redirect(conn, Routes.bank_accounts_path(conn, :index))

      assert html =~ "Withdrawned account!"
    end

    test "give a amout zero when submit the form then return an error",
         %{conn: conn, account: account} do
      {:ok, view, _html} = live(conn, Routes.bank_accounts_path(conn, :index))

      open_modal(view, "withdrawn")

      payload = %{
        account_id: account.id,
        amount: 0
      }

      view
      |> form("#withdrawn",
        moviment_account: payload
      )
      |> render_submit()

      assert has_element?(view, "[data-role=erro-message]", "Amount: must be above zero")
    end

    test "give a account current_balance < amount when submit the form then return an error",
         %{conn: conn, account: account} do
      {:ok, view, _html} = live(conn, Routes.bank_accounts_path(conn, :index))

      open_modal(view, "withdrawn")

      payload = %{
        account_id: account.id,
        amount: 200
      }

      view
      |> form("#withdrawn",
        moviment_account: payload
      )
      |> render_submit()

      assert has_element?(view, "[data-role=erro-message]", "Current balance: insufficient funds")
    end
  end

  defp open_modal(view, action) do
    view
    |> element("[data-role=#{action}-account]")
    |> render_click()
  end
end
