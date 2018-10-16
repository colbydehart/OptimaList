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
        %{
          name: res["name"],
          measurement: normalize_measurement(res["unit"]),
          amount: normalize_amount(res["qty"])
        }
      end)
    else
      _ -> []
    end
  end

  def normalize_amount(nil), do: 0.0
  def normalize_amount(""), do: 1.0
  def normalize_amount("½"), do: 0.5
  def normalize_amount("¾"), do: 0.75
  def normalize_amount("¼"), do: 0.25
  def normalize_amount("⅓"), do: 0.33
  def normalize_amount("⅔"), do: 0.66
  def normalize_amount("1/2"), do: 0.5
  def normalize_amount("1/4"), do: 0.25
  def normalize_amount("3/4"), do: 0.75
  def normalize_amount("1/3"), do: 0.33
  def normalize_amount("2/3"), do: 0.66

  def normalize_amount(string) do
    case Float.parse(string) do
      {res, _} -> res
      :error -> 0.0
    end
  end

  def normalize_measurement(msmt) do
    case msmt do
      "cup" -> "cup"
      "cups" -> "cup"
      "c" -> "cup"
      "gallon" -> "gallon"
      "gallons" -> "gallon"
      "g" -> "gram"
      "gram" -> "gram"
      "liter" -> "liter"
      "litre" -> "liter"
      "ounce" -> "oz"
      "ounces" -> "oz"
      "oz" -> "oz"
      "pound" -> "pound"
      "pounds" -> "pound"
      "lb" -> "pound"
      "lbs" -> "pound"
      "tablespoon" -> "tbsp"
      "tablespoons" -> "tbsp"
      "tbsp" -> "tbsp"
      "teaspoon" -> "tsp"
      "teaspoons" -> "tsp"
      "tsp" -> "tsp"
      _ -> "unit"
    end
  end
end
