defmodule Oinc.Bank.Notifications do
  alias Absinthe.Subscription
  alias OincWeb.Endpoint
  alias Phoenix.PubSub

  @pubsub Oinc.PubSub
  @topic "new_client"

  def subscribe, do: PubSub.subscribe(@pubsub, @topic)

  def broadcast({:error, _} = err), do: err

  def broadcast({:ok, client} = result) do
    PubSub.broadcast(@pubsub, @topic, {:new_client, client})
    Subscription.publish(Endpoint, client, new_client: "new_client")

    result
  end
end
