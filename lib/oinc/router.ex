defmodule Oinc.Router do
  use Commanded.Commands.Router

  alias Oinc.Bank.Aggregates.{Account, Address, Client}
  alias Oinc.Bank.Commands.{CreateAddress, CreateClient, DepositAccount, OpenAccount}

  alias Oinc.Support.Middleware.Validate

  middleware(Validate)

  identify(Account, by: :account_id, prefix: "account-")
  identify(Address, by: :address_id, prefix: "address-")
  identify(Client, by: :client_id, prefix: "client-")

  dispatch(
    [
      DepositAccount,
      OpenAccount
    ],
    to: Account
  )

  dispatch(
    [
      CreateClient
    ],
    to: Client
  )

  dispatch(
    [
      CreateAddress
    ],
    to: Address
  )
end
