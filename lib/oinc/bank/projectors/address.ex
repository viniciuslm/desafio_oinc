defmodule Oinc.Bank.Projectors.Address do
  use Commanded.Projections.Ecto,
    application: Oinc.App,
    name: "Bank.Projectors.Address",
    consistency: :strong

  alias Ecto.Multi

  alias Oinc.Bank.Events.AddressCreated
  alias Oinc.Bank.Projections.Address

  project(%AddressCreated{} = evt, fn multi ->
    Multi.insert(
      multi,
      :address_created,
      %Address{
        id: evt.address_id,
        city: evt.city,
        state: evt.state,
        client_id: evt.client_id
      }
    )
  end)
end
