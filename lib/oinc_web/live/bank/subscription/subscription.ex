defmodule OincWeb.Live.Bank.Subscription do
  use OincWeb, :live_view

  alias Oinc.Bank.Notifications

  alias OincWeb.Live.Bank.Subscription.Row
  alias OincWeb.Live.Component.Empty

  @impl true
  def mount(_, _, socket) do
    if connected?(socket) do
      Notifications.subscribe()
    end

    socket = socket |> assign(new_clients: [])

    {:ok, socket}
  end

  @impl true
  def handle_info({:new_client, new_client}, socket) do
    IO.inspect("teste")
    new_clients = socket.assigns.new_clients ++ [new_client]

    socket = socket |> assign(new_clients: new_clients)
    {:noreply, socket}
  end
end
