defmodule Oinc.Factory do
  use ExMachina.Ecto, repo: Oinc.Repo

  alias Ecto.UUID

  alias Oinc.Accounts.Commands.OpenAccount
  alias Oinc.Accounts.Events.AccountOpened

  def account_factory do
    %{
      account_id: UUID.generate(),
      initial_balance: 100
    }
  end

  def open_account_params_factory do
    %{
      "initial_balance" => 100
    }
  end

  def account_opened_factory do
    struct(AccountOpened, build(:account))
  end

  def open_account_factory do
    struct(OpenAccount, build(:account))
  end

  def deposit_account_params_factory do
    %{
      "deposit_amount" => 100
    }
  end

  def account_deposited_factory do
    struct(AccountDeposited, build(:account))
  end

  def deposit_account_factory do
    struct(DepositAccount, build(:account))
  end
end
