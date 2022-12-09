defmodule Oinc.Bank.Commands.WithdrawnAccount do
  @enforce_keys [:account_id]

  defstruct [:account_id, :withdrawn_amount]

  use ExConstructor
  use Vex.Struct

  validates(:account_id, presence: [message: "can't be empty"], uuid: true)

  validates(:withdrawn_amount, presence: [message: "can't be empty"], integer: true)
end
