defmodule Oinc.Bank.Commands.CreateAddress do
  @enforce_keys [:address_id]

  defstruct [:address_id, :city, :state, :client_id]

  use ExConstructor
  use Vex.Struct

  validates(:address_id, uuid: true)

  validates(:city, presence: [message: "can't be empty"], string: true)

  validates(:state, presence: [message: "can't be empty"], string: true)

  validates(:client_id, presence: [message: "can't be empty"], uuid: true)
end
