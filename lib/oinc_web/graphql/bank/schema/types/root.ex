defmodule OincWeb.Graphql.Bank.Schema.Types.Root do
  use Absinthe.Schema.Notation

  alias Crudry.Middlewares.TranslateErrors
  alias OincWeb.Graphql.Bank.Resolvers
  alias OincWeb.Graphql.Bank.Schema.Types
  alias Resolvers.Account, as: AccountResolver
  alias Resolvers.Address, as: AddresssResolver
  alias Resolvers.Client, as: ClientsResolver

  import_types(Types.Account)
  import_types(Types.Custom.UUID4)
  import_types(Types.Client)
  import_types(Types.Address)

  object :root_query do
    field :client, type: :client do
      arg(:id, non_null(:uuid4))

      resolve(&ClientsResolver.get/2)
    end

    field :address, type: :address do
      arg(:id, non_null(:uuid4))

      resolve(&AddresssResolver.get/2)
    end

    field :account, type: :account do
      arg(:id, non_null(:uuid4))

      resolve(&AccountResolver.get/2)
    end
  end

  object :root_mutation do
    @desc "Create a new client"
    field :create_client, type: :client do
      arg(:input, non_null(:create_client_input))

      resolve(&ClientsResolver.create/2)
      middleware(TranslateErrors)
    end

    @desc "Create a new address"
    field :create_address, type: :address do
      arg(:input, non_null(:create_address_input))

      resolve(&AddresssResolver.create/2)
      middleware(TranslateErrors)
    end

    @desc "Open account"
    field :open_account, type: :account do
      arg(:input, non_null(:open_account_input))

      resolve(&AccountResolver.open/2)
      middleware(TranslateErrors)
    end

    @desc "Close account"
    field :close_account, type: :account do
      arg(:input, non_null(:close_account_input))

      resolve(&AccountResolver.close/2)
      middleware(TranslateErrors)
    end

    @desc "Deposit account"
    field :deposit_account, type: :account do
      arg(:input, non_null(:deposit_account_input))

      resolve(&AccountResolver.deposit/2)
      middleware(TranslateErrors)
    end

    @desc "Withdrawn account"
    field :withdrawn_account, type: :account do
      arg(:input, non_null(:withdrawn_account_input))

      resolve(&AccountResolver.withdrawn/2)
      middleware(TranslateErrors)
    end
  end

  object :root_subscription do
    field :new_client, :client do
      config(fn _args, _info ->
        {:ok, topic: "new_client"}
      end)
    end
  end
end
