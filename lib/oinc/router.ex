defmodule Oinc.Router do
  use Commanded.Commands.Router

  alias Oinc.Bank.Aggregates.{Account, Address, Client}

  alias Oinc.Bank.Commands.{
    CloseAccount,
    CreateAddress,
    CreateClient,
    DepositAccount,
    OpenAccount,
    WithdrawnAccount
  }

  alias Oinc.Support.Middleware.Validate

  middleware(Validate)

  identify(Account, by: :account_id, prefix: "account-")
  identify(Address, by: :address_id, prefix: "address-")
  identify(Client, by: :client_id, prefix: "client-")

  dispatch(
    [
      CloseAccount,
      DepositAccount,
      OpenAccount,
      WithdrawnAccount
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
