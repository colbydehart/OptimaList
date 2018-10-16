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
        Enum.all?(ingredients, &is_map/1) ->
          ingredients

        Enum.all?(ingredients, &is_binary/1) ->
          get_suggestions(ingredients)

        true ->
          []
      end
    else
      _ -> []
    end
  end

  defp get_suggestions(strings) do
    headers = [{"Content-type", "application/json"}]
    url = "https://ingredient-tagger.herokuapp.com"

    with {:ok, %HTTPoison.Response{body: body}} <-
           HTTPoison.post(url, Poison.encode!(%{"ingredients" => strings}), headers),
         {:ok, %{"results" => results}} <- Poison.decode(body) do
      Enum.map(results, fn res ->
        %{name: res["name"], measurement: res["unit"], amount: float_or_zero(res["qty"])}
      end)
    else
      _ -> []
    end
  end

  defp float_or_zero(nil), do: 0.0

  defp float_or_zero(string) do
    case Float.parse(string) do
      {res, _} -> res
      :error -> 0.0
    end
  end
end
