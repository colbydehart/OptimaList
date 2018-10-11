"priv/recipes.json"
|> File.read!()
|> Poison.decode!(keys: :atoms!)
|> Enum.map(&GraphQL.Mutations.create_recipe(nil, &1, nil))
