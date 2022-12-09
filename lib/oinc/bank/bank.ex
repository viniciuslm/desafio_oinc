defmodule Oinc.Bank do
  alias Oinc.Bank.Projectors.Address
  alias Oinc.Bank.Commands.{CreateAddress, CreateClient, DepositAccount, OpenAccount}

  alias Oinc.Bank.Projections.{Account, Address, Client}

  alias Oinc.{App, Repo}

  import Ecto.Query

  def get_account(id) do
    case Repo.get(Account, id) do
      %Account{} = account ->
        {:ok, account}

      _reply ->
        {:error, :not_found}
    end
  end

  def open_account(%{"initial_balance" => initial_balance, "client_id" => client_id}) do
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

  def open_account(_params), do: {:error, :bad_command}

  def deposit(id, amount) do
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

  def get_client(id) do
    case Repo.get(Client, id) do
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

  def create_client(%{"cpf" => cpf, "name" => name}) do
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

  def create_address(%{"city" => city, "state" => state, "client_id" => client_id}) do
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
            city: city
          }
        }

      reply ->
        reply
    end
  end

  def create_address(_params), do: {:error, :bad_command}
end
