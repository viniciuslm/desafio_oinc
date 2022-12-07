defmodule Oinc.Accounts.Projectors.Account do
  use Commanded.Projections.Ecto,
    application: Oinc.App,
    name: "Accounts.Projectors.Account",
    consistency: :strong

  alias Ecto.{Changeset, Multi}

  alias Oinc.Accounts

  alias Oinc.Accounts.Projections.Account

  alias Oinc.Accounts.Events.{AccountOpened, DepositedAccount}

  project(%AccountOpened{} = evt, _metadata, fn multi ->
    Multi.insert(multi, :account_opened, %Account{
      id: evt.account_id,
      current_balance: evt.initial_balance,
      status: Account.status().open
    })
  end)

  project(%DepositedAccount{} = evt, _metadata, fn multi ->
    handle_deposited_account(Accounts.get_account(evt.account_id), multi, evt)
  end)

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
