defmodule Optimalist.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @allowed [:email, :name]

  embedded_schema do
    field :password, :string, virtual: true
    field :email, :string
    field :hash, :string
    field :name, :string

    timestamps()
  end

  def changeset(user, params \\ %{}) do
    user
    |> cast(params, @allowed)
    |> validate_required([:email])
    |> validate_format(:email, ~r/@/, message: "not a valid email")
  end

  def registration_changeset(user, params) do
    user
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 6, message: "password must be at least 6 characters")
    |> hash_password
    |> delete_change(:password)
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
          changeset
    end
  end
end
