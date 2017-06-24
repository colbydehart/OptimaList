defmodule Optimalist.Cypher.Recipe do
  @moduledoc """
  cypher queries for recipe user resource
  """
  def get_user_recipes() do
    """
    MATCH (ingredient:Ingredient)-[requires:Requires]-(recipe:Recipe)--(user:User)
    WHERE ID(user) = $id
    RETURN recipe, requires, ingredient
    """
  end

  def get() do
    """
    MATCH (ingredient:Ingredient)-[requires:Requires]-(recipe:Recipe)
    WHERE ID(recipe) = $id
    RETURN recipe, ingredient, requires
    """
  end

  def create() do
    # need to find already existing ingredients
    """
    MATCH (user:User)
    WHERE ID(user) = $props.user_id
    CREATE (recipe:Recipe {name: $props.name, url: $props.url}) <-[o:Owns]-(user)
    FOREACH(i IN $props.ingredients|
      MERGE (in:Ingredient {name: i.name})
      CREATE (in)<-[r:Requires {quantity: i.quantity, measurement: i.measurement}]-(recipe)
    )
    WITH recipe
    MATCH (ingredient:Ingredient) <-[requires:Requires]-(recipe)
    RETURN recipe, ingredient, requires
    """
  end

  def update() do
    """
    MATCH (r:Recipe)-[:Requires]-(i:Ingredient)
    WHERE ID(r) = $props.id
    SET r = $props
    RETURN r
    """
  end
end
