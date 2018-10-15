defmodule Optimalist.Scraper do
  @moduledoc """
  Module for scraping recipe website HTML and getting a list of ingredients back.
  """

  alias Optimalist.Scraper.FoodNetwork
  alias Optimalist.Scraper.AllRecipes
  alias Optimalist.Scraper.Generic
  alias Optimalist.Scraper.WordPress

  def scrape(url) do
    with {:ok, %HTTPoison.Response{body: body}} <- HTTPoison.get(url) do
      ingredients =
        cond do
          Regex.match?(~r/foodnetwork.com/, url) ->
            FoodNetwork.parse(body)

          Regex.match?(~r/allrecipes.com/, url) ->
            AllRecipes.parse(body)

          String.contains?(body, "wprm-recipe") ->
            WordPress.parse(body)

          true ->
            Generic.parse(body)
        end

      cond do
        Enum.all?(ingredients, &is_map/1) -> ingredients
        Enum.all?(ingredients, &is_binary/1) -> get_suggestions(ingredients)
        true -> []
      end
    end
  end

  defp get_suggestions(strings) do
    headers = [{"Content-type", "application/json"}]

    with {:ok, %HTTPoison.Response{body: body}} <-
           HTTPoison.post(
             "http://localhost:5000",
             Poison.encode!(%{"ingredients" => strings}),
             headers
           ),
         {:ok, %{"results" => results}} <- Poison.decode(body) do
      Enum.map(results, fn res ->
        %{name: res["name"], measurement: res["unit"], amount: res["qty"]}
      end)
    end
  end
end
