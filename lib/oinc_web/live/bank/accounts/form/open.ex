defmodule OincWeb.Live.Bank.Accounts.Form.Open do
  use OincWeb, :live_component

  alias Oinc.Bank
  alias Oinc.Bank.Changeset.OpenAccount, as: ChangesetOpenAccount
  alias Oinc.Bank.Projections.Account

  def update(%{open_account: open_account} = assigns, socket) do
    changeset = ChangesetOpenAccount.changeset(%{})
    clients = Bank.list_clients_form_open_account()

    socket =
      socket
      |> assign(assigns)
      |> assign(changeset: changeset)
      |> assign(clients: clients)
      |> assign(open_account: open_account)

    {:ok, socket}
  end

  def handle_event("validate", %{"open_account" => open_account_params}, socket) do
    changeset =
      socket.assigns.open_account
      |> ChangesetOpenAccount.changeset(open_account_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"open_account" => open_account_params}, socket) do
    action = socket.assigns.action
    save(socket, action, open_account_params)
  end

  defp save(socket, :open, %{"client_id" => client_id, "initial_balance" => initial_balance}) do
    open_account_params = %{
      "client_id" => client_id,
      "initial_balance" => String.to_integer(initial_balance)
    }

    case Bank.open_account(open_account_params) do
      {:ok, %Account{}} ->
        {:noreply,
         socket
         |> put_flash(:info, "Account opened!")
         |> push_redirect(to: Routes.bank_accounts_path(socket, :index))}

      {:error, :validation_failure, error} ->
        send(self(), {:error, error})

        {:noreply, socket}

      {:error, :initial_balance_must_be_above_zero} ->
        send(self(), {:error, %{initial_balance: ["must be above zero"]}})

        {:noreply, socket}
    end
  end
end
