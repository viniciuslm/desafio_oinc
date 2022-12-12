defmodule Oinc.Bank.Aggregates.Address do
  defstruct id: nil,
            client_id: nil,
            city: nil,
            state: nil

  alias __MODULE__

  alias Oinc.Bank.Commands.CreateAddress
  alias Oinc.Bank.Events.AddressCreated

  @doc """
  Creates an address
  """
  def execute(%Address{id: nil}, %CreateAddress{} = create) do
    %AddressCreated{
      address_id: create.address_id,
      client_id: create.client_id,
      city: create.city,
      state: create.state
    }
  end

  # state mutators

  def apply(%Address{} = address, %AddressCreated{} = created) do
    %Address{
      address
      | id: created.address_id,
        city: created.city,
        state: created.state
    }
  end
end
