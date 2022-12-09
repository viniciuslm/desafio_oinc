defmodule Oinc.Bank.Commands.DepositAccount do
  @enforce_keys [:account_id]

  defstruct [:account_id, :deposit_amount]

  use ExConstructor
  use Vex.Struct

  alias Oinc.Bank.Commands.DepositAccount

  validates(:account_id, presence: [message: "can't be empty"], uuid: true)

  validates(:deposit_amount, presence: [message: "can't be empty"], integer: true)

  @doc """
  Assign a unique identity
  """
  def assign_uuid(%DepositAccount{} = deposit_account, id) do
    %DepositAccount{deposit_account | account_id: id}
  end
end
