defmodule Oinc.Support.Validators.Uuid do
  use Vex.Validator

  alias Vex.Validators

  def validate("", _options), do: :ok
  def validate(nil, _options), do: :ok

  def validate(value, _options) do
    Validators.By.validate(value,
      function: &valid_uuid?/1,
      allow_nil: false,
      allow_blank: false
    )
  end

  defp valid_uuid?(id) do
    case Ecto.UUID.cast(id) do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end
end
