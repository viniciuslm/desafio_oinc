defmodule Oinc.Repo.Migrations.CreateAccountsTable do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:current_balance, :integer)
      add(:status, :text)

      timestamps()
    end
  end
end
