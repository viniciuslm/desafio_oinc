defmodule Oinc.Bank.Commands.OpenAccount do
  @enforce_keys [:account_id]

  defstruct [:account_id, :initial_balance, :client_id]

  use ExConstructor
  use Vex.Struct

  alias Oinc.Bank.Commands.OpenAccount
  alias Oinc.Bank.Projections.Client

  validates(:account_id, uuid: true)

  validates(:initial_balance, presence: [message: "can't be empty"], integer: true)

  validates(:client_id, uuid: true)

  @doc """
  Assign a unique identity
  """
  def assign_uuid(%OpenAccount{} = open_account, id) do
    %OpenAccount{open_account | account_id: id}
  end

  @doc """
  Assign the client
  """
  def assign_client(%OpenAccount{} = open_account, %Client{id: id}) do
    %OpenAccount{open_account | client_id: id}
  end
end
