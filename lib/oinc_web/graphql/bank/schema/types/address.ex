defmodule OincWeb.Graphql.Bank.Schema.Types.Address do
  use Absinthe.Schema.Notation

  alias Oinc.Bank

  import Absinthe.Resolution.Helpers, only: [dataloader: 3]

  @desc "Logic model representation"
  object :address do
    field :id, non_null(:uuid4), description: "Address id, need to be an UUID"
    field :city, non_null(:string), description: "Address city"
    field :state, non_null(:string), description: "Address state"

    field :client, non_null(:client), description: "Client Address" do
      resolve dataloader(Bank, :client, args: %{scope: :client})
    end
  end

  input_object :create_address_input do
    field :city, non_null(:string), description: "Address city"
    field :state, non_null(:string), description: "Address state"
    field :client_id, non_null(:uuid4), description: "Client id, need to be an UUID"
  end
end
