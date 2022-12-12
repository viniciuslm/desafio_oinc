defmodule Oinc.Bank.Projections.Client do
  alias Oinc.Bank.Projections.{Account, Address}

  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id

  schema "clients" do
    field(:name, :string)
    field(:cpf, :string)
    field(:status, :string)

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
end
