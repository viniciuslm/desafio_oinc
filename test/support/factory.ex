defmodule Oinc.Factory do
  use ExMachina.Ecto, repo: Oinc.Repo

  alias Ecto.UUID

  alias Oinc.Bank.Commands.OpenAccount
  alias Oinc.Bank.Events.AccountOpened
  alias Oinc.Bank.Projections.{Account, Client}

  def bank_account_factory do
    %{
      account_id: UUID.generate(),
      client_id: UUID.generate(),
      initial_balance: 100
    }
  end

  def open_account_params_factory do
    %{
      "account_id" => nil,
      "initial_balance" => 100,
      "client_id" => nil
    }
  end

  def account_opened_factory do
    struct(AccountOpened, build(:bank_account))
  end

  def open_account_factory do
    struct(OpenAccount, build(:bank_account))
  end

  def deposit_account_params_factory do
    %{
      "deposit_amount" => 100
    }
  end

  def account_deposited_factory do
    struct(AccountDeposited, build(:bank_account))
  end

  def deposit_account_factory do
    struct(DepositAccount, build(:bank_account))
  end

  def client_params_factory do
    %{
      "name" => "Vinicius Moreira",
      "cpf" => "11111111111"
    }
  end

  def client_2_params_factory do
    %{
      "name" => "Vinicius Moreira",
      "cpf" => "22222222222"
    }
  end

  def address_params_factory do
    %{
      "city" => "Belo Horizonte",
      "state" => "MG"
    }
  end

  def client_factory do
    %Client{
      cpf: "02577788622",
      name: "Teste 2",
      id: "ff295d64-4afe-4089-b4ea-e5e8528080ab",
      status: "active"
    }
  end

  def account_factory do
    %Account{
      current_balance: 100,
      status: "open",
      id: "ff295d64-4afe-4089-b4ea-e5e8528080ab",
      client_id: "ff295d64-4afe-4089-b4ea-e5e8528080ab"
    }
  end
end
