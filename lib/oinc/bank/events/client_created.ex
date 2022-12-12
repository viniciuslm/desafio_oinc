defmodule Oinc.Bank.Events.ClientCreated do
  @derive Jason.Encoder
  defstruct [:client_id, :name, :cpf]
end
