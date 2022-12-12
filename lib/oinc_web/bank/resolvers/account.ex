defmodule OincWeb.Bank.Resolvers.Account do
  # alias Absinthe.Subscription
  alias Oinc.Bank
  # alias OincWeb.Endpoint

  def get(%{id: account_id}, _context), do: Bank.get_account(account_id)
  def get_client(account, _args, _context), do: Bank.get_client(account.client_id)
  def open(%{input: params}, _context), do: Bank.open_account(params)
  def close(%{input: %{id: id}}, _context), do: Bank.close_account(id)
  def deposit(%{input: %{id: id, amount: amount}}, _context), do: Bank.deposit(id, amount)
  def withdrawn(%{input: %{id: id, amount: amount}}, _context), do: Bank.withdrawn(id, amount)
end
