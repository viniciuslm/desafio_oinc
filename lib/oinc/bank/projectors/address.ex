defmodule Oinc.Bank.Projectors.Address do
  use Commanded.Projections.Ecto,
    application: Oinc.App,
    name: "Bank.Projectors.Address",
    consistency: :strong

  alias Ecto.Multi

  alias Oinc.Bank
  alias Oinc.Bank.Events.AddressCreated
  alias Oinc.Bank.Projections.{Address, Client}

  project(%AddressCreated{} = evt, _metadata, fn multi ->
    handle_client_address(Bank.get_client(evt.client_id), multi, evt)
  end)

  defp handle_client_address({:ok, %Client{}}, multi, evt) do
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
  end

  defp handle_client_address(_, multi, _), do: multi
end
