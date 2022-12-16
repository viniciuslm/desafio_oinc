defmodule OincWeb.Live.Bank.Address.Form do
  use OincWeb, :live_component

  alias Oinc.Bank
  alias Oinc.Bank.Projections.Address

  def update(%{address: address} = assigns, socket) do
    changeset = Address.changeset(%{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(changeset: changeset)
     |> assign(address: address)}
  end

  def handle_event("validate", %{"address" => address_params}, socket) do
    changeset =
      socket.assigns.address
      |> Address.changeset(address_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"address" => address_params}, socket) do
    action = socket.assigns.action
    save(socket, action, address_params)
  end

  defp save(socket, :address, address_params) do
    case Bank.create_address(address_params) do
      {:ok, %Address{}} ->
        {:noreply,
         socket
         |> put_flash(:info, "Address added!")
         |> push_redirect(to: Routes.bank_clients_path(socket, :index))}

      {:error, error} ->
        {:noreply,
         socket
         |> put_flash(:error, Atom.to_string(error))
         |> push_redirect(to: Routes.bank_clients_path(socket, :index))}
    end
  end
end
