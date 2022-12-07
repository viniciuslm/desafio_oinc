defmodule Oinc.Accounts.Aggregates.Account do
  defstruct id: nil,
            current_balance: nil,
            closed?: false

  alias __MODULE__

  alias Oinc.Accounts.Commands.{DepositAccount, OpenAccount}

  alias Oinc.Accounts.Events.{AccountOpened, DepositedAccount}

  @doc """
  Publish an article
  """
  def execute(%Account{id: nil}, %OpenAccount{
        account_id: account_id,
        initial_balance: initial_balance
      })
      when initial_balance > 0 do
    %AccountOpened{
      account_id: account_id,
      initial_balance: initial_balance
    }
  end

  def execute(
        %Account{id: nil},
        %OpenAccount{
          initial_balance: initial_balance
        }
      )
      when initial_balance <= 0 do
    {:error, :initial_balance_must_be_above_zero}
  end

  def execute(%Account{}, %OpenAccount{}) do
    {:error, :account_already_opened}
  end

  def execute(
        %Account{id: account_id, closed?: false, current_balance: current_balance},
        %DepositAccount{
          account_id: account_id,
          deposit_amount: amount
        }
      )
      when amount > 0 do
    %DepositedAccount{
      account_id: account_id,
      new_current_balance: current_balance + amount
    }
  end

  def execute(
        %Account{closed?: false},
        %DepositAccount{
          deposit_amount: amount
        }
      )
      when amount <= 0 do
    {:error, :amount_must_be_above_zero}
  end

  def execute(
        %Account{id: account_id, closed?: true},
        %DepositAccount{account_id: account_id}
      ) do
    {:error, :account_closed}
  end

  def execute(
        %Account{},
        %DepositAccount{}
      ) do
    {:error, :not_found}
  end

  # state mutators

  def apply(
        %Account{} = account,
        %AccountOpened{
          account_id: account_id,
          initial_balance: initial_balance
        }
      ) do
    %Account{
      account
      | id: account_id,
        current_balance: initial_balance
    }
  end

  def apply(
        %Account{
          id: account_id
        } = account,
        %DepositedAccount{
          account_id: account_id,
          new_current_balance: new_current_balance
        }
      ) do
    %Account{
      account
      | current_balance: new_current_balance
    }
  end
end
