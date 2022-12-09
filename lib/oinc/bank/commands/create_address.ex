defmodule Oinc.Bank.Commands.CreateAddress do
  @enforce_keys [:address_id]

  defstruct [:address_id, :city, :state, :client_id]

  use ExConstructor
  use Vex.Struct

  alias Oinc.Bank.Commands.CreateAddress
  alias Oinc.Bank.Projections.Client

  validates(:address_id, uuid: true)

  validates(:city, presence: [message: "can't be empty"], string: true)

  validates(:state, presence: [message: "can't be empty"], string: true)

  validates(:client_id, presence: [message: "can't be empty"], uuid: true)

  @doc """
  Assign a unique identity
  """
  def assign_uuid(%CreateAddress{} = create_address, id) do
    %CreateAddress{create_address | address_id: id}
  end

  @doc """
  Assign a client
  """
  def assign_client(%CreateAddress{} = create_address, %Client{id: id}) do
    %CreateAddress{create_address | client_id: id}
  end
end
