defmodule Oinc.Bank.Changeset.MovimentAccount do
  import Ecto.Changeset

  defstruct [:amount, :account_id]
  @types %{amount: :integer, account_id: :binary_id}

  def changeset(attrs \\ %{}), do: changeset(%__MODULE__{}, attrs)

  def changeset(moviment_account, attrs) do
    {moviment_account, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:amount, :account_id])
  end
end
