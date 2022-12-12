defmodule Oinc.Repo.Migrations.AddClientsInAccounts do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :client_id,
          references(:clients,
            type: :binary_id,
            null: false
          )
    end

    create index(:accounts, [:client_id])
  end
end
