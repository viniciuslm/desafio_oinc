defmodule Oinc.Bank.Projections.Client do
  use Ecto.Schema
  import Ecto.Changeset
  alias Oinc.Bank.Projections.{Account, Address}

  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id

  schema "clients" do
    field :name, :string
    field :cpf, :string
    field :status, :string

    has_one :address, Address
    has_many :accounts, Account

    timestamps()
  end

  def status do
    %{
      active: "active",
      inactive: "inactive"
    }
  end

  def changeset(attrs \\ %{}), do: changeset(%__MODULE__{}, attrs)

  @doc false
  def changeset(client, attrs) do
    client
    |> cast(attrs, [:name, :cpf, :status])
    |> validate_required([:name, :cpf])
    |> unique_constraint(:cpf)
  end
end
