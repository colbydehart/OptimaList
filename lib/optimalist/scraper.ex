defmodule Optimalist.Scraper do
  @moduledoc """
  Module for scraping recipe website HTML and getting a list of ingredients back.
  """

  alias Optimalist.Scraper.JsonSchema
  alias Optimalist.Scraper.AllRecipes
  alias Optimalist.Scraper.Generic
  alias Optimalist.Scraper.WordPress

  def scrape(url) do
    with {:ok, %HTTPoison.Response{} = response} <- HTTPoison.get(url, [], follow_redirect: true),
         {:ok, body} <- handle_gzip(response) do
      ingredients =
        cond do
          not String.valid?(body) ->
            []

          Regex.match?(~r/allrecipes.com/, url) ->
            AllRecipes.parse(body)

          String.contains?(body, "wprm-recipe") ->
            WordPress.parse(body)

          String.contains?(body, "application/ld+json") &&
              String.contains?(body, "recipeIngredient") ->
            JsonSchema.parse(body)

          true ->
            Generic.parse(body)
        end

      cond do
        Enum.all?(ingredients, &is_map/1) ->
          ingredients

        Enum.all?(ingredients, &is_binary/1) ->
          ingredients
          |> Enum.map(&replace_unicode_characters/1)
          |> Enum.map(&String.downcase/1)
          |> get_suggestions()

        true ->
          []
      end
    else
      _ -> []
    end
  end

  defp handle_gzip(res) do
    gzipped =
      Enum.any?(res.headers, fn kv ->
        case kv do
          {"Content-Encoding", "gzip"} -> true
          {"Content-Encoding", "x-gzip"} -> true
          _ -> false
        end
      end)

    body =
      if gzipped do
        :zlib.gunzip(res.body)
      else
        res.body
      end

    {:ok, body}
  end

  def replace_unicode_characters(str) do
    str
    |> String.replace("½", "1/2")
    |> String.replace("¾", "3/4")
    |> String.replace("¼", "1/4")
    |> String.replace("⅓", "1/3")
    |> String.replace("⅔", "2/3")
    |> String.replace("1⁄4", "1/4")
    |> String.replace("2⁄4", "2/4")
    |> String.replace("3⁄4", "3/4")
    |> String.replace("1⁄3", "1/3")
    |> String.replace("2⁄3", "2/3")
    |> String.replace("1⁄2", "1/2")
    |> String.replace("–", "-")
    |> String.normalize(:nfd)
    |> String.codepoints()
    |> Enum.map(&String.to_charlist/1)
    |> Enum.reject(fn [x] -> x > 127 end)
    |> Enum.join()
  end

  defp get_suggestions(strings) do
    headers = [{"Content-type", "application/json"}]
    url = "https://ingredient-tagger.herokuapp.com"

    with {:ok, %HTTPoison.Response{body: body}} <-
           HTTPoison.post(url, Poison.encode!(%{"ingredients" => strings}), headers),
         {:ok, %{"results" => results}} <- Poison.decode(body) do
      IO.inspect(results)

      Enum.map(results, fn res ->
        %{
          name: res["name"],
          measurement: normalize_measurement(res["unit"] || res["other"]),
          amount: normalize_amount(res["qty"])
        }
      end)
    else
      _ -> []
    end
  end

  def normalize_amount(nil), do: 0.0
  def normalize_amount(""), do: 0.0
  def normalize_amount("½"), do: 0.5
  def normalize_amount("¾"), do: 0.75
  def normalize_amount("¼"), do: 0.25
  def normalize_amount("⅓"), do: 0.33
  def normalize_amount("⅔"), do: 0.66
  def normalize_amount("1⁄2"), do: 0.5
  def normalize_amount("1⁄3"), do: 0.33
  def normalize_amount("1⁄4"), do: 0.25
  def normalize_amount("2⁄3"), do: 0.66
  def normalize_amount("2⁄4"), do: 0.5
  def normalize_amount("3⁄4"), do: 0.75
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

  def normalize_measurement("cup"), do: "cup"
  def normalize_measurement("cups"), do: "cup"
  def normalize_measurement("c"), do: "cup"
  def normalize_measurement("gallon"), do: "gallon"
  def normalize_measurement("gallons"), do: "gallon"
  def normalize_measurement("g"), do: "gram"
  def normalize_measurement("gr"), do: "gram"
  def normalize_measurement("liter"), do: "liter"
  def normalize_measurement("litre"), do: "liter"
  def normalize_measurement("ounce"), do: "oz"
  def normalize_measurement("ounces"), do: "oz"
  def normalize_measurement("oz"), do: "oz"
  def normalize_measurement("oz."), do: "oz"
  def normalize_measurement("pound"), do: "pound"
  def normalize_measurement("pounds"), do: "pound"
  def normalize_measurement("lb"), do: "pound"
  def normalize_measurement("lbs"), do: "pound"
  def normalize_measurement("tablespoon"), do: "tbsp"
  def normalize_measurement("tablespoons"), do: "tbsp"
  def normalize_measurement("tbsp"), do: "tbsp"
  def normalize_measurement("teaspoon"), do: "tsp"
  def normalize_measurement("teaspoons"), do: "tsp"
  def normalize_measurement("tsp"), do: "tsp"
  def normalize_measurement(_), do: "unit"
end
