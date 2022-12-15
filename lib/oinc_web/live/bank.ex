defmodule OincWeb.Live.Bank do
  use OincWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
