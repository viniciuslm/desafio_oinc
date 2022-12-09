defmodule Oinc.Bank.Commands.CreateClient do
  @enforce_keys [:client_id]

  defstruct [:client_id, :name, :cpf]

  use ExConstructor
  use Vex.Struct

  validates(:client_id, uuid: true)

  validates(:name, presence: [message: "can't be empty"], string: true)

  validates(:cpf, presence: [message: "can't be empty"], string: true)
end
