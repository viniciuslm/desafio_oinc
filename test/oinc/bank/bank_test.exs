defmodule Oinc.BankTest do
  use Oinc.DataCase

  alias Ecto.UUID
  alias Oinc.Bank
  alias Oinc.Bank.Projections.{Account, Address, Client}

  setup do
    client_params = build(:client_params)
    {:ok, %Client{} = client} = Bank.create_client(client_params)

    {:ok, client: client}
  end

  describe "open account" do
    @tag :integration
    test "should succeed with valid data", %{client: client} do
      open_account = build(:open_account_params, %{"client_id" => client.id})
      assert {:ok, %Account{} = account} = Bank.open_account(open_account)

      assert(account.current_balance == 100)
      assert account.status == "open"
    end

    test "should an error with invalid data", %{client: client} do
      open_account =
        build(:open_account_params, %{"initial_balance" => 0, "client_id" => client.id})

      assert Bank.open_account(open_account) == {:error, :initial_balance_must_be_above_zero}
    end

    test "should an error invalid no data" do
      assert Bank.open_account(%{}) == {:error, :bad_command}
    end

    test "should an error, client not found" do
      client_id = UUID.generate()
      open_account = build(:open_account_params, %{"client_id" => client_id})
      assert Bank.open_account(open_account) == {:error, :client_not_found}
    end

    test "should an error, invalid integer", %{client: client} do
      open_account =
        build(:open_account_params, %{"client_id" => client.id, "initial_balance" => "string"})

      assert Bank.open_account(open_account) ==
               {:error, :validation_failure, %{initial_balance: ["must be valid"]}}
    end

    test "should an error, empty integer ", %{client: client} do
      open_account =
        build(:open_account_params, %{"client_id" => client.id, "initial_balance" => ""})

      assert Bank.open_account(open_account) ==
               {:error, :validation_failure, %{initial_balance: ["can't be empty"]}}
    end

    test "should an error, nil integer ", %{client: client} do
      open_account =
        build(:open_account_params, %{"client_id" => client.id, "initial_balance" => nil})

      assert Bank.open_account(open_account) ==
               {:error, :validation_failure, %{initial_balance: ["can't be empty"]}}
    end
  end

  describe "close account" do
    setup %{client: client} do
      open_account = build(:open_account_params, %{"client_id" => client.id})
      {:ok, %Account{} = account} = Bank.open_account(open_account)

      {:ok, account: account}
    end

    @tag :integration
    test "should succeed with valid data", %{account: account} do
      assert {:ok, %Account{} = account_closed} = Bank.close_account(account.id)

      assert account_closed.status == "closed"
    end

    test "should an error with not found account" do
      id = UUID.generate()

      assert Bank.close_account(id) == {:error, :not_found}
    end

    test "should an error with account closed", %{account: account} do
      id = account.id

      assert {:ok, %Account{} = account_closed} = Bank.close_account(id)

      assert account_closed.status == "closed"

      assert Bank.close_account(id) ==
               {:error, :account_already_closed}
    end
  end

  describe "deposit into account" do
    setup %{client: client} do
      open_account = build(:open_account_params, %{"client_id" => client.id})
      {:ok, %Account{} = account} = Bank.open_account(open_account)

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

    test "should an error with account closed", %{account: account} do
      amount = 100
      id = account.id

      assert {:ok, %Account{} = account_closed} = Bank.close_account(account.id)

      assert account_closed.status == "closed"

      assert Bank.deposit(id, amount) ==
               {:error, :account_closed}
    end

    test "should an error with not found account" do
      amount = 100
      id = UUID.generate()

      assert Bank.deposit(id, amount) ==
               {:error, :not_found}
    end
  end

  describe "withdrwn from account" do
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

      assert {:ok, %Account{} = withdrawned_account} = Bank.withdrawn(id, amount)

      assert withdrawned_account.current_balance == current_balance - amount
      assert withdrawned_account.status == "open"
    end

    test "should an error with invalid data", %{account: account} do
      amount = 0
      id = account.id

      assert Bank.withdrawn(id, amount) ==
               {:error, :amount_must_be_above_zero}
    end

    test "should an error with account closed", %{account: account} do
      amount = 100
      id = account.id

      assert {:ok, %Account{} = account_closed} = Bank.close_account(account.id)

      assert account_closed.status == "closed"

      assert Bank.withdrawn(id, amount) ==
               {:error, :account_closed}
    end

    test "should an error with not found account" do
      amount = 100
      id = UUID.generate()

      assert Bank.withdrawn(id, amount) ==
               {:error, :not_found}
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

    test "should succeed, but not create client with cpf exist, return client " do
      cpf = "22222222222"
      client_params = build(:client_params, %{"cpf" => cpf})
      Bank.create_client(client_params)
      assert {:ok, %Client{} = client} = Bank.create_client(client_params)

      assert client.cpf == cpf
      assert client.status == "active"
    end

    test "should an error invalid no data" do
      assert Bank.create_client(%{}) == {:error, :bad_command}
    end

    test "should an error, invalid string" do
      cpf = "22222222222"
      client_params = build(:client_params, %{"cpf" => cpf, "name" => 1})

      assert Bank.create_client(client_params) ==
               {:error, :validation_failure, %{name: ["must be valid"]}}
    end

    test "should an error, empty string" do
      cpf = "22222222222"
      client_params = build(:client_params, %{"cpf" => cpf, "name" => ""})

      assert Bank.create_client(client_params) ==
               {:error, :validation_failure, %{name: ["can't be empty"]}}
    end

    test "should an error, nil string" do
      cpf = "22222222222"
      client_params = build(:client_params, %{"cpf" => cpf, "name" => nil})

      assert Bank.create_client(client_params) ==
               {:error, :validation_failure, %{name: ["can't be empty"]}}
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

    test "should an error, client not found" do
      client_id = UUID.generate()
      create_address = build(:address_params, %{"client_id" => client_id})
      assert Bank.create_address(create_address) == {:error, :client_not_found}
    end

    test "should an error, invalid string", %{client: client} do
      create_address = build(:address_params, %{"client_id" => client.id, "city" => ""})

      assert Bank.create_address(create_address) ==
               {:error, :validation_failure, %{city: ["can't be empty"]}}
    end
  end
end
