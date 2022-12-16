defmodule OincWeb.Live.Bank.Clients.Form do
  use OincWeb, :live_component

  alias Oinc.Bank
  alias Oinc.Bank.Projections.Client

  def update(%{client: client} = assigns, socket) do
    changeset = Client.changeset(%{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(changeset: changeset)
     |> assign(client: client)}
  end

  def handle_event("validate", %{"client" => client_params}, socket) do
    changeset =
      socket.assigns.client
      |> Client.changeset(client_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"client" => client_params}, socket) do
    action = socket.assigns.action
    save(socket, action, client_params)
  end

  defp save(socket, :new, client_params) do
    case Bank.create_client(client_params) do
      {:ok, %Client{}} ->
        {:noreply,
         socket
         |> put_flash(:info, "Client added!")
         |> push_redirect(to: Routes.bank_clients_path(socket, :index))}

      {:error, :validation_failure, error} ->
        send(self(), {:error, error})

        {:noreply, socket}

      {:error, error} ->
        {:noreply,
         socket
         |> put_flash(:error, Atom.to_string(error))
         |> push_redirect(to: Routes.bank_clients_path(socket, :index))}
    end
  end
end
