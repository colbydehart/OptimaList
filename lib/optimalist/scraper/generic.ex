defmodule Optimalist.Scraper.Generic do
  @selector """
  .ingredients li,
  .tasty-recipes-ingredients li,
  #mpprecipe-ingredients-list .ingredient,
  li.ingredient,
  .cookbook-ingredient
  """

  def parse(html) do
    html
    |> Floki.find(@selector)
    |> IO.inspect()
    |> Enum.map(&Floki.text/1)
    |> Enum.map(&String.trim/1)
  end
end
