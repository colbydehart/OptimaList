defmodule Optimalist.GraphQL.Mutations do
  alias Optimalist.Neo4j.Repo
  alias Bolt.Sips
  import Optimalist.Neo4j.Util

  def create_recipe(_parent, args, %{context: %{user: user}}) do
    case Repo.create_recipe(args, user.id) do
      {:ok, recipe} ->
        {:ok, recipe}

      _ ->
        {:error, "Could not create recipe"}
    end
  end

  def create_recipe(_, _, _), do: {:error, "unauthenticated"}

  def update_recipe(_parent, args, %{context: %{user: user}}) do
    query = """
    MERGE (r:Recipe {id: {id}})
    """

    case Sips.query(Sips.conn(), query, args) do
      {:ok, [recipe]} ->
        recipe
        |> flatten_node("recipe")
        |> (&{:ok, &1}).()

      _ ->
        {:error, "Could not update recipe."}
    end
  end

  def update_recipe(_, _, _), do: {:error, "unauthenticated"}

  def delete_recipe(_parent, %{id: id}, %{context: %{user: user}}) do
    query = """
    MATCH (u:User)-[:Owns]->(recipe:Recipe)
    WHERE id(recipe) = {id}
    AND id(u) = {user_id}
    OPTIONAL MATCH (recipe)-[rel]-()
    DELETE recipe, rel
    RETURN "ok"
    """

    case Sips.query(Sips.conn(), query, %{id: String.to_integer(id), user_id: user.id}) do
      {:ok, _} ->
        {:ok, %{message: "ok"}}

      _ ->
        {:error, "Could not delete recipe"}
    end
  end

  def delete_recipe(_, _, _), do: {:error, "unauthenticated"}

  def login(_, %{number: number}, _) do
    token =
      Phoenix.Token.sign(OptimalistWeb.Endpoint, Application.get_env(:optimalist, :salt), number)

    code =
      0..5
      |> Enum.map(fn _ -> Enum.random([1, 2, 3, 4, 5, 6]) end)
      |> Enum.join()

    query = """
    MERGE (user:User {number: {number}})
    SET user.token = {token}
    SET user.code = {code}
    RETURN user
    LIMIT 1
    """

    case Sips.query(Sips.conn(), query, %{number: number, token: token, code: code}) do
      {:ok, user} ->
        ExTwilio.Message.create(%{
          from: Application.get_env(:ex_twilio, :from),
          to: number,
          body: "#{code} is your authentication token to login."
        })

        {:ok, %{message: "sent"}}

      _ ->
        {:error, "Could not login at this time."}
    end
  end

  def resolve_login(_, %{code: code}, _) do
    query = """
    MERGE (user:User {code: {code}})
    RETURN user
    """

    with {:ok, [%{"user" => user}]} <- Sips.query(Sips.conn(), query, %{code: code}),
         {:ok, _} <-
           Phoenix.Token.verify(
             OptimalistWeb.Endpoint,
             Application.get_env(:optimalist, :salt),
             user.properties["token"],
             max_age: 86_400
           ) do
      {:ok, %{token: user.properties["token"]}}
    else
      _ ->
        {:error, "Could not log in."}
    end
  end
end
