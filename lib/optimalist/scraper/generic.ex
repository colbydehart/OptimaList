defmodule Optimalist.Scraper.Generic do
  @selector """
  .ingredients li,
  .tasty-recipes-ingredients li,
  .tasty-recipes-ingredients p,
  #mpprecipe-ingredients-list .ingredient,
  .recipe-ingredients li,
  li.ingredient,
  .cookbook-ingredient,
  """

  def parse(html) do
    html
    |> Floki.find(@selector)
    |> Enum.map(&Floki.text/1)
    |> Enum.map(&String.trim/1)
  end
end
