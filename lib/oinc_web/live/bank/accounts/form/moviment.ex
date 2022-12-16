defmodule OincWeb.Live.Bank.Accounts.Form.Moviment do
  use OincWeb, :live_component

  alias Oinc.Bank
  alias Oinc.Bank.Changeset.MovimentAccount, as: ChangesetMovimentAccount
  alias Oinc.Bank.Projections.Account

  def update(%{moviment_account: moviment_account} = assigns, socket) do
    changeset = ChangesetMovimentAccount.changeset(%{})

    socket =
      socket
      |> assign(assigns)
      |> assign(changeset: changeset)
      |> assign(moviment_account: moviment_account)

    {:ok, socket}
  end

  def handle_event("validate", %{"moviment_account" => account_params}, socket) do
    changeset =
      socket.assigns.moviment_account
      |> ChangesetMovimentAccount.changeset(account_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"moviment_account" => account_params}, socket) do
    action = socket.assigns.action
    save(socket, action, account_params)
  end

  defp save(socket, :deposit, %{"account_id" => account_id, "amount" => amount}) do
    amount = String.to_integer(amount)

    case Bank.deposit(account_id, amount) do
      {:ok, %Account{}} ->
        {:noreply,
         socket
         |> put_flash(:info, "Deposited account!")
         |> push_redirect(to: Routes.bank_accounts_path(socket, :index))}

      {:error, :validation_failure, error} ->
        send(self(), {:error, error})

        {:noreply, socket}

      {:error, :amount_must_be_above_zero} ->
        send(self(), {:error, %{amount: ["must be above zero"]}})

        {:noreply, socket}
    end
  end

  defp save(socket, :withdrawn, %{"account_id" => account_id, "amount" => amount}) do
    amount = String.to_integer(amount)

    case Bank.withdrawn(account_id, amount) do
      {:ok, %Account{}} ->
        {:noreply,
         socket
         |> put_flash(:info, "Withdrawned account!")
         |> push_redirect(to: Routes.bank_accounts_path(socket, :index))}

      {:error, :validation_failure, error} ->
        send(self(), {:error, error})

        {:noreply, socket}

      {:error, :amount_must_be_above_zero} ->
        send(self(), {:error, %{amount: ["must be above zero"]}})

        {:noreply, socket}

      {:error, :insufficient_funds} ->
        send(self(), {:error, %{current_balance: ["insufficient funds"]}})

        {:noreply, socket}
    end
  end
end
