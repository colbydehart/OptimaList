defmodule Optimalist.Scraper.Generic do
  @selector """
  .ingredients li
  """

  def parse(html) do
    html
    |> Floki.find(@selector)
    |> Enum.map(&Floki.text/1)
    |> Enum.map(&String.trim/1)
  end
end
