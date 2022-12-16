defmodule OincWeb.Live.ClientsTest do
  use OincWeb.ConnCase
  import Phoenix.LiveViewTest

  test "load page", %{conn: conn} do
    {:ok, _view, html} = live(conn, Routes.bank_path(conn, :index))

    assert html =~ "Home"
  end
end
