defmodule Oinc.Bank.Events.AccountOpened do
  @derive Jason.Encoder
  defstruct [:account_id, :initial_balance, :client_id]
end
