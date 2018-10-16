defmodule Optimalist.Scraper.FoodNetwork do
  def parse(html) do
    with json <- Floki.find(html, "script[type=\"application/ld+json\"]"),
         {"script", _, [raw]} = get_first(json),
         {:ok, %{"recipeIngredient" => ingredients}} <- Poison.decode(raw) do
      ingredients
    else
      _ -> []
    end
  end

  defp get_first([x | _]), do: x
  defp get_first(x), do: x
end
