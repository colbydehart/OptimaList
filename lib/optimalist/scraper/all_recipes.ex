defmodule Optimalist.Scraper.AllRecipes do
  def parse(html) do
    html
    |> Floki.find(".recipe-ingred_text")
    |> Enum.map(&Floki.text/1)
    |> Enum.map(&String.trim/1)
  end
end
