defmodule Optimalist.Accounts.AccountsTest do
  use ExUnit.Case

  alias Optimalist.DB
  alias Optimalist.Accounts

  setup do
    {:ok, _user} = %{changes: %{"email" => "foo@bar.com", "hash" => Comeonin.Bcrypt.hashpwsalt("pass")}}
    |> DB.create_user()
    :ok
  end

  test "logging in a user" do
    {:ok, user} = Accounts.login(%{"email" => "foo@bar.com", "password" => "pass"})
    assert user.email == "foo@bar.com"
  end

  test "registering in a user" do
    {:ok, user} = Accounts.register(%{"email" => "foo@bar.com", "password" => "pass"})
    assert user.email == "foo@bar.com"
  end
end
