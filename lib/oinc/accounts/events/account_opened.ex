defmodule Oinc.Accounts.Events.AccountOpened do
  @derive Jason.Encoder
  defstruct [:account_id, :initial_balance]
end
