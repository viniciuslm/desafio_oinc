defmodule Oinc.Support.Validators.Integer do
  use Vex.Validator
  alias Vex.Validators

  def validate(nil, _options), do: :ok
  def validate("", _options), do: :ok

  def validate(value, _options) do
    Validators.By.validate(value, function: &Kernel.is_integer/1)
  end
end
