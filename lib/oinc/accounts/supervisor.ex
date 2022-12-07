defmodule Oinc.Accounts.Supervisor do
  use Supervisor

  alias Oinc.Accounts.Projectors.Account

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    Supervisor.init(
      [
        Account
      ],
      strategy: :one_for_one
    )
  end
end
