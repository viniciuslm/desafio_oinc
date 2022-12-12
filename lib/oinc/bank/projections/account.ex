defmodule Oinc.Bank.Projections.Account do
  alias Oinc.Bank.Projections.Client
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id

  schema "accounts" do
    field(:current_balance, :integer)
    field(:status, :string)

    belongs_to :client, Client

    has_many :client_accounts, through: [:client, :accounts]

    timestamps()
  end

  def status do
    %{
      open: "open",
      closed: "closed"
    }
  end
end
