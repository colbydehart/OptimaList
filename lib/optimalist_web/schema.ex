defmodule OptimalistWeb.Schema do
  use Absinthe.Schema

  alias OptimalistWeb.Resolvers
  alias OptimalistWeb.Mutations

  object :recipe do
    field(:id, non_null(:id))
    field(:name, non_null(:string))
    field(:url, :string)

    field :recipe_ingredients, non_null(list_of(non_null(:recipe_ingredient))) do
      resolve(&Resolvers.recipe_recipe_ingredients/3)
    end
  end

  object :recipe_ingredient do
    field(:id, non_null(:id))
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

  input_object :recipe_input do
    field(:name, non_null(:string))
    field(:recipe_ingredients, non_null(list_of(non_null(:recipe_ingredient_input))))
    field(:id, non_null(:id))
  end

  input_object :recipe_ingredient_input do
    field(:amount, non_null(:float))
    field(:measurement, non_null(:string))
    field(:ingredient, non_null(:ingredient_input))
  end

  input_object(:ingredient_input) do
    field(:name, non_null(:string))
  end

  query do
    @desc "Get all Recipes"
    field :all_recipes, non_null(list_of(non_null(:recipe))) do
      resolve(&Resolvers.all_recipes/3)
    end

    @desc "Get a single recipe"
    field :recipe_detail, non_null(:recipe) do
      arg(:id, non_null(:id))

      resolve(&Resolvers.recipe_detail/3)
    end

    field :optimalist, non_null(list_of(non_null(:recipe))) do
      resolve(&Resolvers.optimalist/3)
    end
  end

  mutation do
    field :create_recipe, type: :recipe do
      arg(:name, non_null(:string))
      arg(:recipe_ingredients, non_null(list_of(non_null(:recipe_ingredient_input))))

      resolve(&Mutations.create_recipe/3)
    end

    field :update_recipe, :recipe do
      arg(:recipe, non_null(:recipe_input))

      resolve(&Mutations.update_recipe/3)
    end

    field :delete_recipe, :recipe do
      arg(:id, non_null(:id))

      resolve(&Mutations.delete_recipe/3)
    end
  end
end
