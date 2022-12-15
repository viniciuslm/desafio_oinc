defmodule OincWeb.Live.Bank.Clients do
  use OincWeb, :live_view

  alias Oinc.Bank
  alias Oinc.Bank.Projections.{Address, Client}
  alias OincWeb.Live.Bank.Address.Form, as: AddressForm
  alias OincWeb.Live.Bank.Clients.Form
  alias OincWeb.Live.Bank.Clients.Row
  alias OincWeb.Live.Component.Empty

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    clients = Bank.list_client()
    live_action = socket.assigns.live_action

    socket =
      socket
      |> apply_action(live_action, params)
      |> assign(clients: clients)

    {:noreply, socket}
  end

  defp apply_action(socket, :address, %{"id" => id}) do
    socket
    |> assign(:page_title, "Add client address")
    |> assign(:address, %Address{})
    |> assign(:client_id, id)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Add client")
    |> assign(:client, %Client{})
  end

  defp apply_action(socket, :index, _params) do
    socket
  end
end
