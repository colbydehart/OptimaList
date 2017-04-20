defmodule Optimalist.Web.ApiChannel do
  @moduledoc """
  the redux api for the
  """
  use Optimalist.Web, :channel
  alias Optimalist.Accounts
  # TODO: write tests for all of these.

  # when a user logs in, log them in
  # when a user registers, register them
  # when a user adds a recipe, add it
  # when a user updates a recipe, add it
  # when a use deletes a recipe, delete it
  # when a user requests an optimalist, create it
  def join("api", payload, socket) do
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("login", payload, socket) do
    with {:ok, user} <- Accounts.login(payload) do
      {:reply, {:ok, %{user: user}}, socket}
    end
  end
end
