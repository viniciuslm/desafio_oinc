defmodule OincWeb.PageController do
  use OincWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
