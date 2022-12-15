defmodule Oinc.Bank.Notifications do
  alias Phoenix.PubSub

  @pubsub Oinc.PubSub
  @topic "new_client"

  def subscribe, do: PubSub.subscribe(@pubsub, @topic)

  def broadcast({:error, _} = err), do: err

  def broadcast({:ok, client} = result) do
    PubSub.broadcast(@pubsub, @topic, {:new_client, client})
    result
  end
end
