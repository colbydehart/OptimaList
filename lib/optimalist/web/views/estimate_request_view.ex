defmodule Optimalist.Web.EstimateRequestView do
  use Optimalist.Web, :view
  alias Optimalist.Web.EstimateRequestView

  def render("index.json", %{estimate_requests: estimate_requests}) do
    %{data: render_many(estimate_requests, EstimateRequestView, "estimate_request.json")}
  end

  def render("show.json", %{estimate_request: estimate_request}) do
    %{data: render_one(estimate_request, EstimateRequestView, "estimate_request.json")}
  end

  def render("estimate_request.json", %{estimate_request: estimate_request}) do
    %{id: estimate_request.id,
      cost: estimate_request.cost}
  end
end
