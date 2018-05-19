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

  object :optimalist_response do
    field(:recipes, non_null(list_of(non_null(:recipe))))
    field(:list, non_null(list_of(non_null(:list_item))))
  end

  object :list_item do
    field(:amount, non_null(:float))
    field(:measurement, non_null(:string))
    field(:name, non_null(:string))
  end

  object :login_response do
    field(:message, non_null(:string))
  end

  object :resolve_login_response do
    field(:token, non_null(:string))
  end

  object :delete_response do
    field(:message, non_null(:string))
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

    field :optimalist, non_null(:optimalist_response) do
      arg(:length, non_null(:integer))

      resolve(&Resolvers.optimalist/3)
    end
  end

  mutation do
    field :create_recipe, type: :recipe do
      arg(:name, non_null(:string))
      arg(:url, :string)
      arg(:recipe_ingredients, non_null(list_of(non_null(:recipe_ingredient_input))))

      resolve(&Mutations.create_recipe/3)
    end

    field :update_recipe, :recipe do
      arg(:recipe, non_null(:recipe_input))

      resolve(&Mutations.update_recipe/3)
    end

    field :delete_recipe, :delete_response do
      arg(:id, non_null(:id))

      resolve(&Mutations.delete_recipe/3)
    end

    field :login, :login_response do
      arg(:number, non_null(:string))

      resolve(&Mutations.login/3)
    end

    field(:resolve_login, :resolve_login_response) do
      arg(:code, non_null(:string))

      resolve(&Mutations.resolve_login/3)
    end
  end
end
