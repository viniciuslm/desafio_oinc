defmodule Oinc.Bank.Commands.CloseAccount do
  @enforce_keys [:account_id]

  defstruct [:account_id]

  use ExConstructor
  use Vex.Struct

  validates(:account_id, uuid: true)
end
