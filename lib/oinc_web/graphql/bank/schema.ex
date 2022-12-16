defmodule OincWeb.Graphql.Bank.Schema do
  use Absinthe.Schema

  alias Oinc.Bank

  import_types(OincWeb.Graphql.Bank.Schema.Types.Root)

  query do
    import_fields(:root_query)
  end

  mutation do
    import_fields(:root_mutation)
  end

  subscription do
    import_fields(:root_subscription)
  end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Bank, Bank.datasource())

    Map.put(ctx, :loader, loader)
  end

  def plugins, do: [Absinthe.Middleware.Dataloader | Absinthe.Plugin.defaults()]
end
