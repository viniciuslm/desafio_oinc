defmodule Oinc.Bank.Changeset.OpenAccount do
  import Ecto.Changeset

  defstruct [:initial_balance, :client_id]
  @types %{initial_balance: :integer, client_id: :binary_id}

  def changeset(attrs \\ %{}), do: changeset(%__MODULE__{}, attrs)

  def changeset(open_account, attrs) do
    {open_account, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:initial_balance, :client_id])
  end
end
