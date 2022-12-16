defmodule OincWeb.Live.Component.Error do
  use OincWeb, :live_component

  def update(%{error: error} = assigns, socket) do
    message = parse_error(error)

    socket =
      socket
      |> assign(assigns)
      |> assign(message: message)

    {:ok, socket}
  end

  defp parse_error(error) do
    items = Map.keys(error)

    generate_message("", items, error)
  end

  defp generate_message(message, [item | items], error) do
    message
    |> generate_messagem_item(item, Map.get(error, item))
    |> generate_message(items, error)
  end

  defp generate_message(message, [], _), do: message

  defp generate_messagem_item(message, item, [item_message | messages]) do
    message
    |> parse_item_message(item, item_message)
    |> generate_messagem_item(item, messages)
  end

  defp generate_messagem_item(message, _, []), do: message

  defp parse_item_message(message, item, item_message) do
    item =
      item
      |> Atom.to_string()
      |> humanize()

    message <> item <> ": " <> item_message <> "\n"
  end
end
