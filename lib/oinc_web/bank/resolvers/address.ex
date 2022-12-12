defmodule OincWeb.Bank.Resolvers.Address do
  alias Oinc.Bank

  def get(%{id: address_id}, _context), do: Bank.get_address(address_id)
  def create(%{input: params}, _context), do: Bank.create_address(params)
end
