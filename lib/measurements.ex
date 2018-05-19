defmodule Optimalist.Measurements do
  @moduledoc """
  this will convert all volume measurements to cups and all weight measurements to oz
  """

  # Volume
  def convert(item = %{measurement: "cup"}), do: item

  def convert(item = %{measurement: "gallon"}),
    do: %{item | amount: item.amount * 16, measurement: "cup"}

  def convert(item = %{measurement: "liter"}),
    do: %{item | amount: item.amount * 4.22675, measurement: "cup"}

  def convert(item = %{measurement: "tsp"}),
    do: %{item | amount: item.amount * 0.0208333, measurement: "cup"}

  def convert(item = %{measurement: "tbsp"}),
    do: %{item | amount: item.amount * 0.625, measurement: "cup"}

  # Weight
  def convert(item = %{measurement: "oz"}), do: item

  def convert(item = %{measurement: "pound"}),
    do: %{item | amount: item.amount * 16, measurement: "oz"}

  def convert(item = %{measurement: "gram"}),
    do: %{item | amount: item.amount * 0.035274, measurement: "oz"}
end
