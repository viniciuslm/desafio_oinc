defmodule OincWeb.LiveHelpers do
  import Phoenix.LiveView.Helpers
  alias Phoenix.LiveView.JS

  def modal(assigns) do
    ~H"""
    <div id="modal" class="phx-modal fade-in justify-center items-center h-modal sm:h-full z-index:30" data-role="modal" phx-remove={hide_modal()}>
      <div
            id="modal-content"
            class="phx-modal-content fade-in-scale relative w-full max-w-2xl px-4 h-full md:h-auto"
            phx-click-away={JS.dispatch("click", to: "#close")}
            phx-window-keydown={JS.dispatch("click", to: "#close")}
            phx-key="escape"
          >
          <!-- Modal content -->
            <div class="bg-white rounded-lg shadow relative">
                <!-- Modal header -->
                <div class="flex items-start justify-between p-3 border-b rounded-t">
                    <h3 class="text-xl font-semibold">
                        <%= @titulo %>
                    </h3>
                    <a href={@return_to} id="close" class="phx-modal-close" phx-click={hide_modal()}>
                    <button type="button" class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm p-1.5 ml-auto inline-flex items-center">
                        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path></svg>
                    </button>
                    </a>
                </div>

                <%= render_slot(@inner_block) %>
            </div>
      </div>
    </div>
    """
  end

  def modal_error(assigns) do
    ~H"""
    <div id="modal_error" class="phx-modal fade-in justify-center items-center h-modal sm:h-full z-index:30" data-role="modal" phx-remove={hide_modal_error()}>
      <div
            id="hide_modal_error-conten5"
            class="phx-modal-content fade-in-scale relative w-full max-w-2xl px-4 h-full md:h-auto"
            phx-click-away={JS.dispatch("click", to: "#close")}
            phx-window-keydown={JS.dispatch("click", to: "#close")}
            phx-key="escape"
          >
          <!-- Modal content -->
            <div class="bg-white rounded-lg shadow relative">
                <!-- Modal header -->
                <div class="flex items-start justify-between p-4 border-b rounded-t">
                    <h3 class="text-xl font-semibold">
                        <%= @titulo %>
                    </h3>
                </div>
            </div>

            <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  def modal_close(assigns) do
    ~H"""
    <div id="modal" class="phx-modal fade-in justify-center items-center h-modal sm:h-full" data-role="modal" phx-remove={hide_modal()}>
      <div
            id="modal-content"
            class="phx-modal-content fade-in-scale relative w-full max-w-2xl px-4 h-full md:h-auto"
            phx-click-away={JS.dispatch("click", to: "#close")}
            phx-window-keydown={JS.dispatch("click", to: "#close")}
            phx-key="escape"
          >
          <!-- Modal content -->
            <div class="bg-white rounded-lg shadow relative">
                <!-- Modal header -->
                <div class="flex items-start justify-between p-4 border-b rounded-t">
                    <h3 class="text-xl font-semibold">
                        <%= @titulo %>
                    </h3>
                    <a href={@return_to} class="phx-modal-close" phx-click={hide_modal()}>
                    <button type="button" class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm p-1.5 ml-auto inline-flex items-center">
                        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path></svg>
                    </button>
                    </a>
                </div>
            </div>

            <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end

  defp hide_modal_error(js \\ %JS{}) do
    js
    |> JS.hide(to: "#hide_modal_error", transition: "fade-out")
    |> JS.hide(to: "#hide_modal_error-content", transition: "fade-out-scale")
  end

  def show_modal(js \\ %JS{}) do
    js
    |> JS.show(to: "#modal", transition: "fade-in")
    |> JS.show(to: "#modal-content", transition: "fade-in-scale")
  end

  def show_modal_error(js \\ %JS{}) do
    js
    |> JS.show(to: "#modal_error", transition: "fade-in")
    |> JS.show(to: "#modal-content_error", transition: "fade-in-scale")
  end
end
