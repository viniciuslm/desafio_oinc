defmodule Oinc.Accounts.Events.DepositedAccount do
  @derive Jason.Encoder
  defstruct [:account_id, :new_current_balance]
end
