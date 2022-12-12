defmodule Oinc.Repo.Migrations.CreateClientsTable do
  use Ecto.Migration

  def change do
    create table(:clients, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:name, :string)
      add(:cpf, :string)
      add(:status, :string)

      timestamps()
    end

    create unique_index(:clients, [:cpf])
  end
end
