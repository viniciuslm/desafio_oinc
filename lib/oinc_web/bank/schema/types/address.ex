defmodule OincWeb.Bank.Schema.Types.Address do
  use Absinthe.Schema.Notation

  alias OincWeb.Bank.Resolvers.Address

  @desc "Logic model representation"
  object :address do
    field :id, non_null(:uuid4), description: "Address id, need to be an UUID"
    field :city, non_null(:string), description: "Address city"
    field :state, non_null(:string), description: "Address state"
    field :client, non_null(:client), resolve: &Address.get_client/3
  end

  input_object :create_address_input do
    field :city, non_null(:string), description: "Address city"
    field :state, non_null(:string), description: "Address state"
    field :client_id, non_null(:uuid4), description: "Client id, need to be an UUID"
  end
end