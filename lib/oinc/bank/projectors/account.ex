defmodule Oinc.Bank.Projectors.Account do
  use Commanded.Projections.Ecto,
    application: Oinc.App,
    name: "Bank.Projectors.Account",
    consistency: :strong

  alias Ecto.{Changeset, Multi}

  alias Oinc.Bank

  alias Oinc.Bank.Projections.Account

  alias Oinc.Bank.Events.{AccountClosed, AccountOpened, DepositedAccount, WithdrawnedAccount}

  project(%AccountOpened{} = evt, fn multi ->
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
  end)

  project(%AccountClosed{} = evt, fn multi ->
    {:ok, %Account{} = account} = Bank.get_account(evt.account_id)

    Multi.update(
      multi,
      :account,
      Changeset.change(account, status: Account.status().closed)
    )
  end)

  project(%DepositedAccount{} = evt, fn multi ->
    handle_deposited_withdrawned_account(
      :deposited_account,
      Bank.get_account(evt.account_id),
      multi,
      evt
    )
  end)

  project(%WithdrawnedAccount{} = evt, fn multi ->
    handle_deposited_withdrawned_account(
      :withdrawned_account,
      Bank.get_account(evt.account_id),
      multi,
      evt
    )
  end)

  defp handle_deposited_withdrawned_account(name, {:ok, %Account{} = account}, multi, evt) do
    Multi.update(
      multi,
      name,
      Changeset.change(
        account,
        current_balance: evt.new_current_balance
      )
    )
  end
end
