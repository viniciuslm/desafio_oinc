defmodule OincWeb.Bank.Resolvers.Client do
  alias Oinc.Bank

  def get(%{id: client_id}, _context), do: Bank.get_client(client_id)
  def create(%{input: params}, _context), do: Bank.create_client(params)
end
