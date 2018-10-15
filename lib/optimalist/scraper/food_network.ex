defmodule Optimalist.Scraper.FoodNetwork do
  def parse(html) do
    with json <- Floki.find(html, "script[type=\"application/ld+json\"]"),
         {"script", _, [raw]} = get_first(json),
         {:ok, %{"recipeIngredient" => ingredients}} <- Poison.decode(raw),
         do: ingredients
  end

  defp get_first(x) when is_list(x), do: hd(x)
  defp get_first(x), do: x
end
