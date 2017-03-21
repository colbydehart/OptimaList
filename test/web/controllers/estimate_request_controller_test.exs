defmodule Optimalist.Web.EstimateRequestControllerTest do
  use Optimalist.Web.ConnCase

  alias Optimalist.Quoter
  alias Optimalist.Quoter.EstimateRequest

  @create_attrs %{cost: "120.5"}
  @update_attrs %{cost: "456.7"}
  @invalid_attrs %{cost: nil}

  def fixture(:estimate_request) do
    {:ok, estimate_request} = Quoter.create_estimate_request(@create_attrs)
    estimate_request
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, estimate_request_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "creates estimate_request and renders estimate_request when data is valid", %{conn: conn} do
    conn = post conn, estimate_request_path(conn, :create), estimate_request: @create_attrs
    assert %{"id" => id} = json_response(conn, 201)["data"]

    conn = get conn, estimate_request_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "cost" => "120.5"}
  end

  test "does not create estimate_request and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, estimate_request_path(conn, :create), estimate_request: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates chosen estimate_request and renders estimate_request when data is valid", %{conn: conn} do
    %EstimateRequest{id: id} = estimate_request = fixture(:estimate_request)
    conn = put conn, estimate_request_path(conn, :update, estimate_request), estimate_request: @update_attrs
    assert %{"id" => ^id} = json_response(conn, 200)["data"]

    conn = get conn, estimate_request_path(conn, :show, id)
    assert json_response(conn, 200)["data"] == %{
      "id" => id,
      "cost" => "456.7"}
  end

  test "does not update chosen estimate_request and renders errors when data is invalid", %{conn: conn} do
    estimate_request = fixture(:estimate_request)
    conn = put conn, estimate_request_path(conn, :update, estimate_request), estimate_request: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen estimate_request", %{conn: conn} do
    estimate_request = fixture(:estimate_request)
    conn = delete conn, estimate_request_path(conn, :delete, estimate_request)
    assert response(conn, 204)
    assert_error_sent 404, fn ->
      get conn, estimate_request_path(conn, :show, estimate_request)
    end
  end
end
