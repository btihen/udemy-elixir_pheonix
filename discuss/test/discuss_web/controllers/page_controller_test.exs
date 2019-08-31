defmodule DiscussWeb.PageControllerTest do
  use DiscussWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Phoenix 1.4.9!"
  end
end
