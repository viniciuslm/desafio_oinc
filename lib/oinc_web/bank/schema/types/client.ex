defmodule OincWeb.Bank.Schema.Types.Client do
  use Absinthe.Schema.Notation

  @desc "Logic client representation"
  object :client do
    field :id, non_null(:uuid4), description: "Client id, need to be an UUID"
    field :cpf, non_null(:string), description: "Client cpf"
    field :name, non_null(:string), description: "Client name"
    field :status, non_null(:string), description: "Client status"
    field :address, non_null(:address), description: "Address Client"
  end

  input_object :create_client_input do
    field :name, non_null(:string), description: "Client name"
    field :cpf, non_null(:string), description: "Client cpf"
  end
end