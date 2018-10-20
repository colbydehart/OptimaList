defmodule Optimalist.Neo4j.Util do
  alias Bolt.Sips
  alias Optimalist.Measurements

  @spec flatten_nodes([Sips.Response], binary | nil) :: [map]
  def flatten_nodes(nodes, key \\ nil), do: Enum.map(nodes, &flatten_node(&1, key))

  @doc """
  Takes in a response for a node and merges its properties with
  its ID then atomizes the resulting map
  """
  @spec flatten_node(Sips.Response, binary | nil) :: map
  def flatten_node(node, key \\ nil) do
    data =
      case key do
        nil -> node
        _ -> Map.get(node, key)
      end

    data =
      data.properties
      |> Map.put("id", data.id)
      |> atomize_map
  end

  defp atomize_map(map) do
    map
    |> Enum.map(fn {k, v} ->
      if is_atom(k) do
        {k, v}
      else
        {String.to_existing_atom(k), v}
      end
    end)
    |> Enum.into(%{})
  end

  def merge_same_ingredients({key, ings}), do: Enum.reduce(ings, [], &reduce_ingredients/2)

  def reduce_ingredients(ing, acc) do
    converted = Measurements.convert(ing)

    case(Enum.find(acc, &(Map.get(&1, :measurement) === converted.measurement))) do
      nil ->
        [converted | acc]

      _ ->
        acc
        |> Enum.map(fn i ->
          Map.update(i, :amount, 0, &(&1 + converted.amount))
        end)
    end
  end

  def condense_measurements(ing) do
    case ing do
      %{measurement: "cup", amount: amount} when amount < 1 ->
        %{ing | amount: amount / 0.0208333, measurement: "tsp"}

      _ ->
        ing
    end
  end
end
