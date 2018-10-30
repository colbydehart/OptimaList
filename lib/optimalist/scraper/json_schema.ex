defmodule Optimalist.Scraper.JsonSchema do
  def parse(html) do
    with json <- Floki.find(html, "script[type=\"application/ld+json\"]"),
         first when not is_nil(first) <- get_first(json),
         {"script", _, [raw]} = first,
         {:ok, %{"recipeIngredient" => ingredients}} <- Poison.decode(raw),
         ingredients <- handle_single_ingredient(ingredients) do
      ingredients
    else
      _ -> Optimalist.Scraper.Generic.parse(html)
    end
  end

  defp get_first(scripts) when is_list(scripts) do
    Enum.find(scripts, fn {"script", _, [raw]} -> String.contains?(raw, "recipeIngredient") end)
  end

  defp get_first(script), do: script

  defp handle_single_ingredient(ings) when length(ings) == 1 do
    ings
    |> hd()
    |> String.split("\n")
  end

  defp handle_single_ingredient(ings), do: ings
end
