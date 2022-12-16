defmodule Oinc.Bank.NotificationsTest do
  use Oinc.DataCase
  alias Oinc.Bank.Notifications

  test "should subscribe to receive new events" do
    Notifications.subscribe()
    assert {:messages, []} == Process.info(self(), :messages)
  end

  test "should receive broadcast message" do
    Notifications.subscribe()
    assert {:messages, []} == Process.info(self(), :messages)

    Notifications.broadcast({:ok, %{id: "123"}})
    assert {:messages, [{:new_client, client}]} = Process.info(self(), :messages)
    assert client.id == "123"
  end

  test "should receive error broadcast" do
    Notifications.subscribe()
    assert {:messages, []} == Process.info(self(), :messages)

    Notifications.broadcast({:error, %{id: "123"}})
    assert {:messages, []} = Process.info(self(), :messages)
  end
end
