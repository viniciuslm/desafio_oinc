defmodule Oinc.Bank.Events.AddressCreated do
  @derive Jason.Encoder
  defstruct [:address_id, :city, :state, :client_id]
end
