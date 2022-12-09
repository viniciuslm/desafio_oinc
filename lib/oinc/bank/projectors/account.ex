defmodule Oinc.Bank.Projectors.Account do
  use Commanded.Projections.Ecto,
    application: Oinc.App,
    name: "Bank.Projectors.Account",
    consistency: :strong

  alias Ecto.{Changeset, Multi}

  alias Oinc.Bank

  alias Oinc.Bank.Projections.{Account, Client}

  alias Oinc.Bank.Events.{AccountOpened, DepositedAccount}

  project(%AccountOpened{} = evt, _metadata, fn multi ->
    handle_client_account(Bank.get_client(evt.client_id), multi, evt)
  end)

  project(%DepositedAccount{} = evt, _metadata, fn multi ->
    handle_deposited_account(Bank.get_account(evt.account_id), multi, evt)
  end)

  defp handle_client_account({:ok, %Client{}}, multi, evt) do
    Multi.insert(
      multi,
      :account_opened,
      %Account{
        id: evt.account_id,
        current_balance: evt.initial_balance,
        client_id: evt.client_id,
        status: Account.status().open
      }
    )
  end

  defp handle_client_account(_, multi, _), do: multi

  defp handle_deposited_account({:ok, %Account{} = account}, multi, evt) do
    Multi.update(
      multi,
      :deposited_account,
      Changeset.change(
        account,
        current_balance: evt.new_current_balance
      )
    )
  end

  defp handle_deposited_account(_, multi, _), do: multi
end
