defmodule Oinc.Bank.Commands.CreateClient do
  @enforce_keys [:client_id]

  defstruct [:client_id, :name, :cpf]

  use ExConstructor
  use Vex.Struct

  alias Oinc.Bank.Commands.CreateClient

  validates(:client_id, uuid: true)

  validates(:name, presence: [message: "can't be empty"], string: true)

  validates(:cpf, presence: [message: "can't be empty"], string: true)

  @doc """
  Assign a unique identity
  """
  def assign_uuid(%CreateClient{} = create_client, id) do
    %CreateClient{create_client | client_id: id}
  end
end
