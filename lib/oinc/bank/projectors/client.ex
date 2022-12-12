defmodule Oinc.Bank.Projectors.Client do
  use Commanded.Projections.Ecto,
    application: Oinc.App,
    name: "Bank.Projectors.Client",
    consistency: :strong

  alias Ecto.Multi

  alias Oinc.Bank
  alias Oinc.Bank.Events.ClientCreated
  alias Oinc.Bank.Projections.Client

  project(%ClientCreated{} = evt, _metadata, fn multi ->
    handle_client_created(Bank.get_client_by_cpf(evt.cpf), multi, evt)
  end)

  defp handle_client_created({:error, :not_found}, multi, evt) do
    Multi.insert(multi, :client_created, %Client{
      id: evt.client_id,
      name: evt.name,
      cpf: evt.cpf,
      status: Client.status().active
    })
  end

  defp handle_client_created({:ok, %Client{} = client}, multi, _evt) do
    Multi.one(multi, :client_created, Bank.query_client(client.cpf))
  end
end
