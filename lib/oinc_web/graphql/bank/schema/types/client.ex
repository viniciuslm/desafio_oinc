defmodule OincWeb.Graphql.Bank.Schema.Types.Client do
  use Absinthe.Schema.Notation

  alias Oinc.Bank

  import Absinthe.Resolution.Helpers, only: [dataloader: 3]

  @desc "Logic client representation"
  object :client do
    field :id, non_null(:uuid4), description: "Client id, need to be an UUID"
    field :cpf, non_null(:string), description: "Client cpf"
    field :name, non_null(:string), description: "Client name"
    field :status, non_null(:string), description: "Client status"

    field :address, :address, description: "Address Client" do
      resolve dataloader(Bank, :address, args: %{scope: :client})
    end

    field :accounts, list_of(:account), description: "Account Client" do
      resolve dataloader(Bank, :accounts, args: %{scope: :client})
    end
  end

  input_object :create_client_input do
    field :name, non_null(:string), description: "Client name"
    field :cpf, non_null(:string), description: "Client cpf"
  end
end
