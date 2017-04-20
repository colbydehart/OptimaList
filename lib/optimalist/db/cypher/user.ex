defmodule Optimalist.Cypher.User do
  @moduledoc """
  cypher queries for the user resource
  """
  def get() do
    """
    MATCH (n:User)
    WHERE ID(n) = $id
    RETURN n
    """
  end

  def get_by_email() do
    """
    MATCH(n:User)
    WHERE n.email = $email
    RETURN n
    """
  end

  def delete() do
    """
    MATCH (n:User)
    WHERE ID(n) = $id
    DELETE n
    """
  end

  def create() do
    """
    CREATE (n:User $props)
    RETURN n
    """
  end

  def update() do
    """
    MATCH (n:User)
    WHERE ID(n) = $id
    SET n = $props
    """
  end
end
