defmodule OincWeb.Bank.Schema.Types.Account do
  use Absinthe.Schema.Notation

  alias OincWeb.Bank.Resolvers

  @desc "Logic account representation"
  object :account do
    field :id, non_null(:uuid4), description: "Accounts id, need to be an UUID"
    field :current_balance, non_null(:integer), description: "Accounts current_balance"
    field :status, non_null(:string), description: "Accounts status"

    field :client, non_null(:client),
      resolve: &Resolvers.Address.get_client/3,
      description: "Accounts client_id"
  end

  input_object :open_account_input do
    field :initial_balance, non_null(:integer),
      description: "Accounts current_initial_balancebalance"

    field :client_id, non_null(:uuid4), description: "Client id, need to be an UUID"
  end
end
