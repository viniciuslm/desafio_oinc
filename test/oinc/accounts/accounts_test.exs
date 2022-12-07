defmodule Oinc.AccountsTest do
  use Oinc.DataCase

  alias Oinc.Accounts
  alias Oinc.Accounts.Projections.Account

  describe "open account" do
    @tag :integration
    test "should succeed with valid data" do
      open_account = build(:open_account_params)
      assert {:ok, %Account{} = account} = Accounts.open_account(open_account)

      assert account.current_balance == 100
      assert account.status == "open"
    end

    test "should an error with invalid data" do
      open_account = build(:open_account_params, %{"initial_balance" => 0})
      assert Accounts.open_account(open_account) == {:error, :initial_balance_must_be_above_zero}
    end

    test "should an error invalid no data" do
      assert Accounts.open_account(%{}) == {:error, :bad_command}
    end
  end

  describe "deposit into account" do
    setup do
      open_account = build(:open_account_params)
      assert {:ok, %Account{} = account} = Accounts.open_account(open_account)

      {:ok, account: account}
    end

    @tag :integration
    test "should succeed with valid data", %{account: account} do
      amount = 100
      id = account.id
      current_balance = account.current_balance

      assert {:ok, %Account{} = deposited_account} = Accounts.deposit(id, amount)

      assert deposited_account.current_balance == current_balance + amount
      assert deposited_account.status == "open"
    end

    test "should an error with invalid data", %{account: account} do
      amount = 0
      id = account.id

      assert Accounts.deposit(id, amount) ==
               {:error, :amount_must_be_above_zero}
    end
  end
end
