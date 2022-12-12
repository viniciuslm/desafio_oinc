defmodule Oinc.Repo.Migrations.CreateAddressClientsTable do
  use Ecto.Migration

  def change do
    create table(:address_clients, primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:city, :string)
      add(:state, :string)

      add :client_id,
          references(:clients,
            type: :binary_id,
            null: false
          )

      timestamps()
    end

    create index(:address_clients, [:client_id])
  end
end
