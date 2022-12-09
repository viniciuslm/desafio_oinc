defmodule Oinc.Bank.Events.WithdrawnedAccount do
  @derive Jason.Encoder
  defstruct [:account_id, :new_current_balance]
end
