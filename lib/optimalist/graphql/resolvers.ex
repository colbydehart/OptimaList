defmodule Optimalist.GraphQL.Resolvers do
  @moduledoc """
  All of the resolvers for the graphql queries
  """
  alias Optimalist.Neo4j.Repo
  alias Optimalist.UserCache

  def me(_, %{token: token}, _), do: user_by_token(token)
  def me(_, _, _), do: {:error, "Unauthenticated"}

  def all_recipes(_, _, %{context: %{user: user}}) do
    case Repo.all_recipes(user.id) do
      {:ok, recipes} ->
        {:ok, recipes}

      _ ->
        {:error, "Could not fetch recipes"}
    end
  end

  def all_recipes(_, _, _), do: {:error, message: "unauthenticated"}

  def recipe_detail(_parent, %{id: id}, %{context: %{user: user}}) do
    case Repo.recipe_detail(id, user.id) do
      {:ok, recipe} ->
        {:ok, recipe}

      _ ->
        {:error, "Could not fetch Recipe"}
    end
  end

  def recipe_detail(_, _, _), do: {:error, "unauthenticated"}

  def recipe_recipe_ingredients(parent, _args, %{context: %{user: _user}}) do
    case Repo.recipe_recipe_ingredients(parent.id) do
      {:ok, recipe_ingredients} ->
        {:ok, recipe_ingredients}

      _ ->
        {:error, "Could not fetch recipe ingredients"}
    end
  end

  def recipe_recipe_ingredients(_, _, _), do: {:error, "unauthenticated"}

  def recipe_ingredient_recipe(parent, _args, %{context: %{user: user}}) do
    case Repo.recipe_ingredient_recipe(parent.id) do
      {:ok, recipe} ->
        {:ok, recipe}

      _ ->
        {:error, "Could not fetch recipe."}
    end
  end

  def recipe_ingredient_recipe(_, _, _), do: {:error, "unauthenticated"}

  def optimalist(_, %{length: length}, %{context: %{user: user}}) do
    case Repo.optimalist(length, user.id) do
      {:ok, %{recipes: recipes, list: list}} ->
        {:ok, %{recipes: recipes, list: list}}

      _ ->
        {:error, "Could not create optimalist"}
    end
  end

  def optimalist(_, _, _), do: {:error, "unauthenticated"}

  def suggestions(_, %{url: url}, %{context: %{user: _user}}),
    do: {:ok, Optimalist.Scraper.scrape(url)}

  def suggestions(_, _, _), do: {:error, "unauthenticated"}

  def user_by_token(token) do
    case UserCache.user_by_token(token) do
      {:ok, user} ->
        {:ok, user}

      _ ->
        {:error, "Could not fetch user"}
    end
  end
end
