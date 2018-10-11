defmodule Optimalist.Scraper.AllRecipes do
  def parse(url) do
    with {:ok, html} <- request(url) do
      html
      |> Floki.find(".recipe-print__container2 ul li")
      |> Enum.map(fn {_, _, [text]} -> text end)
      |> Enum.map(&String.trim/1)
    end
  end

  def request(url) do
    url =
      cond do
        String.ends_with?(url, "/print/") -> url
        String.ends_with?(url, "/print") -> url <> "/"
        true -> String.trim_trailing(url, "/") <> "/print/"
      end

    with {:ok, %HTTPoison.Response{body: body}} <- HTTPoison.get(url), do: {:ok, body}
  end
end
