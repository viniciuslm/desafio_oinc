defmodule Oinc.Bank.Commands.OpenAccount do
  @enforce_keys [:account_id]

  defstruct [:account_id, :initial_balance, :client_id]

  use ExConstructor
  use Vex.Struct

  validates(:account_id, uuid: true)

  validates(:initial_balance, presence: [message: "can't be empty"], integer: true)

  validates(:client_id, uuid: true)
end
