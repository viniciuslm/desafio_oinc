defmodule Oinc.Bank.Projections.Address do
  use Ecto.Schema
  import Ecto.Changeset
  alias Oinc.Bank.Projections.Client

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "address_clients" do
    field :state, :string
    field :city, :string

    belongs_to :client, Client

    timestamps()
  end

  def changeset(attrs \\ %{}), do: changeset(%__MODULE__{}, attrs)

  @doc false
  def changeset(address, attrs) do
    address
    |> cast(attrs, [:city, :state, :client_id])
    |> validate_required([:city, :state, :client_id])
    |> unique_constraint(:client_id)
  end
end
