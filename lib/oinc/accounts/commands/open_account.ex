defmodule Oinc.Accounts.Commands.OpenAccount do
  @enforce_keys [:account_id]

  defstruct [:account_id, :initial_balance]

  use ExConstructor
  use Vex.Struct

  alias Oinc.Accounts.Commands.OpenAccount

  validates(:account_id, uuid: true)

  validates(:initial_balance, presence: [message: "can't be empty"], integer: true)

  @doc """
  Assign a unique identity
  """
  def assign_uuid(%OpenAccount{} = open_account, id) do
    %OpenAccount{open_account | account_id: id}
  end
end
