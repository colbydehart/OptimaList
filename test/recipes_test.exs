defmodule Optimalist.RecipesTest do
  use Optimalist.DataCase

  alias Optimalist.Recipes
  alias Optimalist.Recipes.Recipe

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:recipe, attrs \\ @create_attrs) do
    {:ok, recipe} = Recipes.create_recipe(attrs)
    recipe
  end

  test "list_recipes/1 returns all recipes" do
    recipe = fixture(:recipe)
    assert Recipes.list_recipes() == [recipe]
  end

  test "get_recipe! returns the recipe with given id" do
    recipe = fixture(:recipe)
    assert Recipes.get_recipe!(recipe.id) == recipe
  end

  test "create_recipe/1 with valid data creates a recipe" do
    assert {:ok, %Recipe{} = recipe} = Recipes.create_recipe(@create_attrs)
    assert recipe.name == "some name"
  end

  test "create_recipe/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Recipes.create_recipe(@invalid_attrs)
  end

  test "update_recipe/2 with valid data updates the recipe" do
    recipe = fixture(:recipe)
    assert {:ok, recipe} = Recipes.update_recipe(recipe, @update_attrs)
    assert %Recipe{} = recipe
    assert recipe.name == "some updated name"
  end

  test "update_recipe/2 with invalid data returns error changeset" do
    recipe = fixture(:recipe)
    assert {:error, %Ecto.Changeset{}} = Recipes.update_recipe(recipe, @invalid_attrs)
    assert recipe == Recipes.get_recipe!(recipe.id)
  end

  test "delete_recipe/1 deletes the recipe" do
    recipe = fixture(:recipe)
    assert {:ok, %Recipe{}} = Recipes.delete_recipe(recipe)
    assert_raise Ecto.NoResultsError, fn -> Recipes.get_recipe!(recipe.id) end
  end

  test "change_recipe/1 returns a recipe changeset" do
    recipe = fixture(:recipe)
    assert %Ecto.Changeset{} = Recipes.change_recipe(recipe)
  end
end
