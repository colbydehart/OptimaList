defmodule Web.ApiControllerTest do
  use Web.ConnCase

  alias Web.Api
  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "Gets a response from api", %{conn: conn} do
    conn = get conn, api_path(conn, :index)
    assert json_response(conn, 200) == "Hello"
  end
end
