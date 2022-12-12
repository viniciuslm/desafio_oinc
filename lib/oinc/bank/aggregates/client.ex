defmodule Oinc.Bank.Aggregates.Client do
  defstruct id: nil,
            name: nil,
            cpf: nil

  alias __MODULE__

  alias Oinc.Bank.Commands.CreateClient
  alias Oinc.Bank.Events.ClientCreated

  @doc """
  Creates an client
  """
  def execute(%Client{id: nil}, %CreateClient{} = create) do
    %ClientCreated{
      client_id: create.client_id,
      name: create.name,
      cpf: create.cpf
    }
  end

  # state mutators

  def apply(%Client{} = client, %ClientCreated{} = created) do
    %Client{
      client
      | id: created.client_id,
        name: created.name,
        cpf: created.cpf
    }
  end
end
