defmodule Optimalist.Scraper.FoodNetwork do
  def parse(url) do
    with {:ok, html} <- request(url),
         [{"script", _, [json]}] <- Floki.find(html, "script[type=\"application/ld+json\"]"),
         {:ok, %{"recipeIngredient" => ingredients}} <- Poison.decode(json),
         do: ingredients
  end

  def request(url) do
    with {:ok, %HTTPoison.Response{body: body}} <- HTTPoison.get(url), do: {:ok, body}
  end
end
