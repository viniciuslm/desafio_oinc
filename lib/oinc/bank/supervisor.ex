defmodule Oinc.Bank.Supervisor do
  use Supervisor

  alias Oinc.Bank.Projectors.{Account, Address, Client}

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    Supervisor.init(
      [
        Account,
        Address,
        Client
      ],
      strategy: :one_for_one
    )
  end
end
