defmodule OincWeb.Live.Bank.Accounts do
  use OincWeb, :live_view

  alias Oinc.Bank
  alias Oinc.Bank.Changeset.{MovimentAccount, OpenAccount}
  alias Oinc.Bank.Projections.Account
  alias OincWeb.Live.Bank.Accounts.Form.Close
  alias OincWeb.Live.Bank.Accounts.Form.Moviment
  alias OincWeb.Live.Bank.Accounts.Form.Open
  alias OincWeb.Live.Bank.Accounts.Row
  alias OincWeb.Live.Component.Empty
  alias OincWeb.Live.Component.Error

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    accounts = Bank.list_accounts()
    live_action = socket.assigns.live_action

    socket =
      socket
      |> apply_action(live_action, params)
      |> assign(accounts: accounts)
      |> assign(validation_failure: false)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:error, error}, socket) do
    socket =
      socket
      |> assign(error: error)
      |> assign(validation_failure: true)

    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    delete(socket, id)
  end

  defp apply_action(socket, :open, _params) do
    socket
    |> assign(:page_title, "Open account")
    |> assign(:open_account, %OpenAccount{})
  end

  defp apply_action(socket, :deposit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Deposit account")
    |> assign(:moviment_account, %MovimentAccount{})
    |> assign(:account_id, id)
  end

  defp apply_action(socket, :withdrawn, %{"id" => id}) do
    socket
    |> assign(:page_title, "Withdrawn account")
    |> assign(:moviment_account, %MovimentAccount{})
    |> assign(:account_id, id)
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  defp apply_action(socket, :close, %{"id" => id}) do
    socket
    |> assign(:page_title, "Close account")
    |> assign(:account_id, id)
  end

  defp delete(socket, id) do
    case Bank.close_account(id) do
      {:ok, %Account{}} ->
        {:noreply,
         socket
         |> put_flash(:info, "Closed account!")
         |> push_redirect(to: Routes.bank_accounts_path(socket, :index))}

      {:error, :validation_failure, error} ->
        send(self(), {:error, error})

        {:noreply, socket}

      {:error, :amount_must_be_above_zero} ->
        send(self(), {:error, %{amount: ["must be above zero"]}})

        {:noreply, socket}
    end
  end
end
