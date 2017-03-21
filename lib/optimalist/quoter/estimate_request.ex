defmodule Optimalist.Quoter.EstimateRequest do
  use Ecto.Schema

  schema "quoter_estimate_requests" do
    field :cost, :float

    timestamps()
  end
end
