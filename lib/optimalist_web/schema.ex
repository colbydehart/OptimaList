defmodule OptimalistWeb.Schema do
  use Absinthe.Schema

  alias OptimalistWeb.Resolvers

  object :recipe do
    field(:id, non_null(:id))
    field(:name, non_null(:string))

    field :recipe_ingredients, non_null(list_of(non_null(:recipe_ingredient))) do
      resolve(&Resolvers.recipe_recipe_ingredients/3)
    end
  end

  object :recipe_ingredient do
    field(:amount, non_null(:float))
    field(:measurement, non_null(:string))

    field :ingredient, non_null(:ingredient) do
      resolve(&Resolvers.recipe_ingredient_recipe/3)
    end
  end

  object :ingredient do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
  end

  query do
    @desc "Get all Recipes"
    field :all_recipes, non_null(list_of(non_null(:recipe))) do
      resolve(&Resolvers.all_recipes/3)
    end
  end
end
