defmodule Oinc.Bank do
  alias Oinc.Bank.Projectors.Address

  alias Oinc.Bank.Commands.{
    CloseAccount,
    CreateAddress,
    CreateClient,
    DepositAccount,
    OpenAccount,
    WithdrawnAccount
  }

  alias Oinc.Bank.Projections.{Account, Address, Client}

  alias Oinc.{App, Repo}

  import Ecto.Query

  def get_account(id) do
    case Account
         |> join(:left, [a], a2 in Account, on: a2.client_id == a.client_id and a2.id != a.id)
         |> where([a], a.id == ^id)
         |> preload([:client_accounts])
         |> Repo.one() do
      %Account{} = account ->
        {:ok, account}

      _reply ->
        {:error, :not_found}
    end
  end

  def open_account(%{"initial_balance" => initial_balance, "client_id" => client_id}),
    do: open_account(%{initial_balance: initial_balance, client_id: client_id})

  def open_account(%{initial_balance: initial_balance, client_id: client_id}),
    do:
      check_client_open_account(get_client(client_id), %{
        "initial_balance" => initial_balance,
        "client_id" => client_id
      })

  def open_account(_params), do: {:error, :bad_command}

  def close_account(id), do: check_account_close_account(get_account(id), id)

  def deposit(id, amount), do: check_account_deposit(get_account(id), id, amount)

  def withdrawn(id, amount), do: check_account_withdrawn(get_account(id), id, amount)

  def get_client(id) do
    case Client
         |> join(:left, [c], a in Address, on: c.id == a.client_id)
         |> where([c], c.id == ^id)
         |> preload([:address])
         |> Repo.one() do
      %Client{} = client ->
        {:ok, client}

      _reply ->
        {:error, :not_found}
    end
  end

  def get_client_by_cpf(cpf) do
    case Repo.get_by(Client, cpf: cpf) do
      %Client{} = client ->
        {:ok, client}

      _reply ->
        {:error, :not_found}
    end
  end

  def query_client(cpf), do: from(a in Client, where: a.cpf == ^cpf)

  def create_client(%{"cpf" => cpf, "name" => name}), do: create_client(%{cpf: cpf, name: name})

  def create_client(%{cpf: cpf, name: name}) do
    id = Ecto.UUID.generate()

    dispatch_result =
      %CreateClient{
        client_id: id,
        name: name,
        cpf: cpf
      }
      |> App.dispatch(consistency: :strong)

    case dispatch_result do
      :ok ->
        {
          :ok,
          %Client{
            id: id,
            name: name,
            cpf: cpf,
            status: Client.status().active
          }
        }

      reply ->
        reply
    end
  end

  def create_client(_params), do: {:error, :bad_command}

  def get_address(id) do
    case Repo.get(Address, id) do
      %Address{} = address ->
        {:ok, address}

      _reply ->
        {:error, :not_found}
    end
  end

  def get_address_by_client_id(client_id),
    do: Repo.get_by(Address, client_id: client_id)

  def create_address(%{"city" => city, "state" => state, "client_id" => client_id}),
    do: create_address(%{city: city, state: state, client_id: client_id})

  def create_address(%{city: city, state: state, client_id: client_id}) do
    check_client_create_address(get_client(client_id), %{
      "city" => city,
      "state" => state,
      "client_id" => client_id
    })
  end

  def create_address(_params), do: {:error, :bad_command}

  defp check_client_open_account({:ok, %Client{}}, %{
         "initial_balance" => initial_balance,
         "client_id" => client_id
       }) do
    id = Ecto.UUID.generate()

    dispatch_result =
      %OpenAccount{
        initial_balance: initial_balance,
        client_id: client_id,
        account_id: id
      }
      |> App.dispatch(consistency: :strong)

    case dispatch_result do
      :ok ->
        {
          :ok,
          %Account{
            id: id,
            current_balance: initial_balance,
            client_id: client_id,
            status: Account.status().open
          }
        }

      reply ->
        reply
    end
  end

  defp check_client_open_account(_, _), do: {:error, :client_not_found}

  defp check_account_close_account({:ok, %Account{}}, id) do
    dispatch_result =
      %CloseAccount{
        account_id: id
      }
      |> App.dispatch(consistency: :strong)

    case dispatch_result do
      :ok ->
        {:ok,
         %Account{
           id: id,
           status: Account.status().closed
         }}

      reply ->
        reply
    end
  end

  defp check_account_close_account(_, _), do: {:error, :not_found}

  defp check_account_deposit({:ok, %Account{}}, id, amount) do
    dispatch_result =
      %DepositAccount{
        account_id: id,
        deposit_amount: amount
      }
      |> App.dispatch(consistency: :strong)

    case dispatch_result do
      :ok ->
        {
          :ok,
          Repo.get!(Account, id)
        }

      reply ->
        reply
    end
  end

  defp check_account_deposit(_, _, _), do: {:error, :not_found}

  defp check_account_withdrawn({:ok, %Account{}}, id, amount) do
    dispatch_result =
      %WithdrawnAccount{
        account_id: id,
        withdrawn_amount: amount
      }
      |> App.dispatch(consistency: :strong)

    case dispatch_result do
      :ok ->
        {
          :ok,
          Repo.get!(Account, id)
        }

      reply ->
        reply
    end
  end

  defp check_account_withdrawn(_, _, _), do: {:error, :not_found}

  defp check_client_create_address({:ok, %Client{}}, %{
         "city" => city,
         "state" => state,
         "client_id" => client_id
       }) do
    id = Ecto.UUID.generate()

    dispatch_result =
      %CreateAddress{
        address_id: id,
        state: state,
        city: city,
        client_id: client_id
      }
      |> App.dispatch(consistency: :strong)

    case dispatch_result do
      :ok ->
        {
          :ok,
          %Address{
            id: id,
            state: state,
            client_id: client_id,
            city: city
          }
        }

      reply ->
        reply
    end
  end

  defp check_client_create_address(_, _), do: {:error, :client_not_found}
end
