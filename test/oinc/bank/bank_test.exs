defmodule Oinc.BankTest do
  use Oinc.DataCase

  alias Oinc.Bank
  alias Oinc.Bank.Projections.{Account, Address, Client}

  setup do
    client_params = build(:client_params)
    assert {:ok, %Client{} = client} = Bank.create_client(client_params)

    {:ok, client: client}
  end

  describe "open account" do
    @tag :integration
    test "should succeed with valid data", %{client: client} do
      open_account = build(:open_account_params, %{"client_id" => client.id})
      assert {:ok, %Account{} = account} = Bank.open_account(open_account)

      assert account.current_balance == 100
      assert account.status == "open"
    end

    test "should an error with invalid data" do
      open_account = build(:open_account_params, %{"initial_balance" => 0})
      assert Bank.open_account(open_account) == {:error, :initial_balance_must_be_above_zero}
    end

    test "should an error invalid no data" do
      assert Bank.open_account(%{}) == {:error, :bad_command}
    end
  end

  describe "deposit into account" do
    setup %{client: client} do
      open_account = build(:open_account_params, %{"client_id" => client.id})
      assert {:ok, %Account{} = account} = Bank.open_account(open_account)

      {:ok, account: account}
    end

    @tag :integration
    test "should succeed with valid data", %{account: account} do
      amount = 100
      id = account.id
      current_balance = account.current_balance

      assert {:ok, %Account{} = deposited_account} = Bank.deposit(id, amount)

      assert deposited_account.current_balance == current_balance + amount
      assert deposited_account.status == "open"
    end

    test "should an error with invalid data", %{account: account} do
      amount = 0
      id = account.id

      assert Bank.deposit(id, amount) ==
               {:error, :amount_must_be_above_zero}
    end
  end

  describe "create client" do
    @tag :integration
    test "should succeed with valid data" do
      cpf = "22222222222"
      client_params = build(:client_params, %{"cpf" => cpf})
      assert {:ok, %Client{} = client} = Bank.create_client(client_params)

      assert client.cpf == cpf
      assert client.status == "active"
    end

    test "should an error invalid no data" do
      assert Bank.create_client(%{}) == {:error, :bad_command}
    end
  end

  describe "create address" do
    @tag :integration
    test "should succeed with valid data", %{client: client} do
      create_address = build(:address_params, %{"client_id" => client.id})
      assert {:ok, %Address{} = adress} = Bank.create_address(create_address)

      assert adress.city == "Belo Horizonte"
      assert adress.state == "MG"
    end

    test "should an error invalid no data" do
      assert Bank.create_address(%{}) == {:error, :bad_command}
    end
  end
end
