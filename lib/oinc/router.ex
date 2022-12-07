defmodule Oinc.Router do
  use Commanded.Commands.Router

  alias Oinc.Accounts.Aggregates.Account
  alias Oinc.Accounts.Commands.{DepositAccount, OpenAccount}

  alias Oinc.Support.Middleware.Validate

  middleware(Validate)

  identify(Account, by: :account_id, prefix: "account-")

  dispatch(
    [
      DepositAccount,
      OpenAccount
    ],
    to: Account
  )
end
