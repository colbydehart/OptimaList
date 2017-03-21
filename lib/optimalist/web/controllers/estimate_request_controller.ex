defmodule Optimalist.Web.EstimateRequestController do
  use Optimalist.Web, :controller

  alias Optimalist.Quoter
  alias Optimalist.Quoter.EstimateRequest

  action_fallback Optimalist.Web.FallbackController

  def index(conn, _params) do
    estimate_requests = Quoter.list_estimate_requests()
    render(conn, "index.json", estimate_requests: estimate_requests)
  end

  def create(conn, %{"estimate_request" => estimate_request_params}) do
    with {:ok, %EstimateRequest{} = estimate_request} <- Quoter.create_estimate_request(estimate_request_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", estimate_request_path(conn, :show, estimate_request))
      |> render("show.json", estimate_request: estimate_request)
    end
  end

  def show(conn, %{"id" => id}) do
    estimate_request = Quoter.get_estimate_request!(id)
    render(conn, "show.json", estimate_request: estimate_request)
  end

  def update(conn, %{"id" => id, "estimate_request" => estimate_request_params}) do
    estimate_request = Quoter.get_estimate_request!(id)

    with {:ok, %EstimateRequest{} = estimate_request} <- Quoter.update_estimate_request(estimate_request, estimate_request_params) do
      render(conn, "show.json", estimate_request: estimate_request)
    end
  end

  def delete(conn, %{"id" => id}) do
    estimate_request = Quoter.get_estimate_request!(id)
    with {:ok, %EstimateRequest{}} <- Quoter.delete_estimate_request(estimate_request) do
      send_resp(conn, :no_content, "")
    end
  end
end
