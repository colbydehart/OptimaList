defmodule Optimalist.Scraper.JsonSchema do
  def parse(html) do
    with json <- Floki.find(html, "script[type=\"application/ld+json\"]"),
         {"script", _, [raw]} = get_first(json),
         {:ok, %{"recipeIngredient" => ingredients}} <- Poison.decode(raw) do
      ingredients
    else
      _ -> []
    end
  end

  defp get_first(scripts) when is_list(scripts) do
    Enum.find(scripts, fn {"script", _, [raw]} -> String.contains?(raw, "recipeIngredient") end)
  end

  defp get_first(script), do: script
end
