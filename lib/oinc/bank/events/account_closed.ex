defmodule Oinc.Bank.Events.AccountClosed do
  @derive Jason.Encoder
  defstruct [:account_id]
end
