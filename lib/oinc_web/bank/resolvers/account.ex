defmodule OincWeb.Bank.Resolvers.Account do
  alias Absinthe.Subscription
  alias Oinc.Bank
  alias OincWeb.Endpoint

  def get(%{id: account_id}, _context), do: Bank.get_account(account_id)
  def get_client(account, _args, _context), do: Bank.get_client(account.client_id)

  def open(%{input: params}, _context) do
    case Bank.open_account(params) do
      {:error, resaon} ->
        {:error, resaon}

      {:ok, account} ->
        Subscription.publish(Endpoint, account, open_account: "open_account_topic")
        {:ok, account}
    end
  end
end
