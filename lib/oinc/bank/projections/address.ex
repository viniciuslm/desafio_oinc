defmodule Oinc.Bank.Projections.Address do
  alias Oinc.Bank.Projections.Client

  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "address_clients" do
    field :state, :string
    field :city, :string

    belongs_to :client, Client

    timestamps()
  end
end
