defmodule OptimalistWeb.Context do
  @behaviour Plug

  import Plug.Conn
  alias GraphQL.Resolvers

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  def build_context(conn) do
    with [token] <- get_req_header(conn, "authorization"),
         {:ok, user} <- Resolvers.user_by_token(token),
         {:ok, _} <-
           Phoenix.Token.verify(
             OptimalistWeb.Endpoint,
             Application.get_env(:optimalist, :salt),
             token,
             max_age: 86_400
           ) do
      %{user: user}
    else
      _ ->
        %{}
    end
  end
end
