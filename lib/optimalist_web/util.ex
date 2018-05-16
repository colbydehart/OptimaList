defmodule OptimalistWeb.Util do
  @spec flatten_nodes([Sips.Response], binary) :: [map]
  def flatten_nodes(nodes, key \\ "node"), do: Enum.map(nodes, &flatten_node(&1, key))

  @doc """
  Takes in a response for a node and merges its properties with
  its ID then atomizes the resulting map
  """
  @spec flatten_node(Sips.Response, binary) :: map
  def flatten_node(node, key \\ "node") do
    data = Map.get(node, key)

    data.properties
    |> Map.put("id", data.id)
    |> atomize_map
  end

  @doc """
  takes a map that may have string keys and turns them all into atoms.
  """
  @spec atomize_map(map) :: map
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
end
