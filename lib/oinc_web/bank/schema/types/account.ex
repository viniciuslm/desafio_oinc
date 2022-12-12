defmodule OincWeb.Bank.Schema.Types.Account do
  use Absinthe.Schema.Notation

  alias Oinc.Bank

  import Absinthe.Resolution.Helpers, only: [dataloader: 3]

  @desc "Logic account representation"
  object :account do
    field :id, non_null(:uuid4), description: "Accounts id, need to be an UUID"
    field :current_balance, non_null(:integer), description: "Accounts current_balance"
    field :status, non_null(:string), description: "Accounts status"

    field :client, non_null(:client), description: "Client Account" do
      resolve dataloader(Bank, :client, args: %{scope: :client})
    end

    field :client_accounts, list_of(:account), description: "Accounts Client Account" do
      resolve dataloader(Bank, :client_accounts, args: %{scope: :client})
    end
  end

  input_object :open_account_input do
    field :initial_balance, non_null(:integer), description: "Accounts initial_balance"
    field :client_id, non_null(:uuid4), description: "Client id, need to be an UUID"
  end

  input_object :close_account_input do
    field :id, non_null(:uuid4), description: "Account id, need to be an UUID"
  end

  input_object :deposit_account_input do
    field :id, non_null(:uuid4), description: "Account id, need to be an UUID"
    field :amount, non_null(:integer), description: "Deposit Account Amount"
  end

  input_object :withdrawn_account_input do
    field :id, non_null(:uuid4), description: "Account id, need to be an UUID"
    field :amount, non_null(:integer), description: "Withdrawn Account Amount"
  end
end
