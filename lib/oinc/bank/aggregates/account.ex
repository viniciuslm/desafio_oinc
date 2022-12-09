defmodule Oinc.Bank.Aggregates.Account do
  defstruct id: nil,
            current_balance: nil,
            client_id: nil,
            closed?: false

  alias __MODULE__

  alias Oinc.Bank.Commands.{CloseAccount, DepositAccount, OpenAccount, WithdrawnAccount}

  alias Oinc.Bank.Events.{AccountClosed, AccountOpened, DepositedAccount, WithdrawnedAccount}

  def execute(%Account{id: nil}, %OpenAccount{
        account_id: account_id,
        client_id: client_id,
        initial_balance: initial_balance
      })
      when initial_balance > 0 do
    %AccountOpened{
      account_id: account_id,
      client_id: client_id,
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

  def execute(
        %Account{id: account_id, closed?: true},
        %CloseAccount{
          account_id: account_id
        }
      ) do
    {:error, :account_already_closed}
  end

  def execute(
        %Account{id: account_id, closed?: false},
        %CloseAccount{
          account_id: account_id
        }
      ) do
    %AccountClosed{
      account_id: account_id
    }
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
        %Account{id: account_id, closed?: false, current_balance: current_balance},
        %WithdrawnAccount{
          account_id: account_id,
          withdrawn_amount: amount
        }
      )
      when amount > 0 do
    if current_balance - amount >= 0 do
      %WithdrawnedAccount{
        account_id: account_id,
        new_current_balance: current_balance - amount
      }
    else
      {:error, :insufficient_funds}
    end
  end

  def execute(
        %Account{},
        %WithdrawnAccount{
          withdrawn_amount: amount
        }
      )
      when amount <= 0 do
    {:error, :amount_must_be_above_zero}
  end

  def execute(
        %Account{id: account_id, closed?: true},
        %WithdrawnAccount{account_id: account_id}
      ) do
    {:error, :account_closed}
  end

  # state mutators

  def apply(
        %Account{} = account,
        %AccountOpened{
          account_id: account_id,
          client_id: client_id,
          initial_balance: initial_balance
        }
      ) do
    %Account{
      account
      | id: account_id,
        client_id: client_id,
        current_balance: initial_balance
    }
  end

  def apply(
        %Account{id: account_id} = account,
        %AccountClosed{
          account_id: account_id
        }
      ) do
    %Account{
      account
      | closed?: true
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

  def apply(
        %Account{
          id: account_id
        } = account,
        %WithdrawnedAccount{
          account_id: account_id,
          new_current_balance: new_current_balance
        }
      ) do
    %Account{
      account
      | current_balance: new_current_balance
    }
  end

  # defp check_client({:ok, %Client{}}, return), do: return

  # defp check_client(_, _), do: {:error, :client_not_found}
end
