defmodule Oinc.Support.Validators.String do
  use Vex.Validator
  alias Vex.Validators

  def validate(nil, _options), do: :ok
  def validate("", _options), do: :ok

  def validate(value, _options) do
    Validators.By.validate(value, function: &String.valid?/1)
  end
end
