defmodule Oinc.Bank.Commands.DepositAccount do
  @enforce_keys [:account_id]

  defstruct [:account_id, :deposit_amount]

  use ExConstructor
  use Vex.Struct

  validates(:account_id, presence: [message: "can't be empty"], uuid: true)

  validates(:deposit_amount, presence: [message: "can't be empty"], integer: true)
end
