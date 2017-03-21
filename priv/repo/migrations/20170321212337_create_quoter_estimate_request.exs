defmodule Optimalist.Repo.Migrations.CreateOptimalist.Quoter.EstimateRequest do
  use Ecto.Migration

  def change do
    create table(:quoter_estimate_requests) do
      add :cost, :float

      timestamps()
    end

  end
end
