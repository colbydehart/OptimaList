defmodule Optimalist.Scraper do
  @moduledoc """
  Module for scraping recipe website HTML and getting a list of ingredients back.
  """

  alias Optimalist.Scraper.FoodNetwork
  alias Optimalist.Scraper.AllRecipes

  def scrape(url) do
    ingredients =
      cond do
        Regex.match?(~r/foodnetwork.com/, url) -> FoodNetwork.parse(url)
        Regex.match?(~r/allrecipes.com/, url) -> AllRecipes.parse(url)
        true -> []
      end

    ingredients
  end
end
