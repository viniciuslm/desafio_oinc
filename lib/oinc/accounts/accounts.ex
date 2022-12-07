defmodule Oinc.Accounts do
  alias Oinc.Accounts.Commands.{DepositAccount, OpenAccount}

  alias Oinc.Accounts.Projections.Account

  alias Oinc.{App, Repo}

  def get_account(id) do
    case Repo.get(Account, id) do
      %Account{} = account ->
        {:ok, account}

      _reply ->
        {:error, :not_found}
    end
  end

  def open_account(%{"initial_balance" => initial_balance}) do
    id = Ecto.UUID.generate()

    dispatch_result =
      %OpenAccount{
        initial_balance: initial_balance,
        account_id: id
      }
      |> App.dispatch(consistency: :strong)

    case dispatch_result do
      :ok ->
        {
          :ok,
          %Account{
            id: id,
            current_balance: initial_balance,
            status: Account.status().open
          }
        }

      reply ->
        reply
    end
  end

  def open_account(_params), do: {:error, :bad_command}

  def deposit(id, amount) do
    dispatch_result =
      %DepositAccount{
        account_id: id,
        deposit_amount: amount
      }
      |> App.dispatch(consistency: :strong)

    case dispatch_result do
      :ok ->
        {
          :ok,
          Repo.get!(Account, id)
        }

      reply ->
        reply
    end
  end
end
