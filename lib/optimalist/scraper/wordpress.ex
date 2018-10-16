defmodule Optimalist.Scraper.WordPress do
  alias Optimalist.Scraper

  def parse(html) do
    with nodes <- Floki.find(html, ".wprm-recipe-ingredient") do
      nodes
      |> Enum.map(fn node ->
        [name, measurement, amount] =
          ~w(.wprm-recipe-ingredient-name .wprm-recipe-ingredient-unit .wprm-recipe-ingredient-amount)
          |> Enum.map(&Floki.find(node, &1))
          |> Enum.map(&Floki.text/1)

        %{
          name: name,
          measurement: Scraper.normalize_measurement(measurement),
          amount: Scraper.normalize_amount(amount)
        }
      end)
    end
  end
end
