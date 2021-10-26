defmodule TimeManager.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]


  schema "users" do
    field :email, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email])
    |> validate_required([:username, :email])
    |> validate_format(:email, ~r/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/, message: "Doit être au format email")
  end
  def getByUsernameAndEmail(query, email, username) do
      from users in query,
      where: users.email == ^email and users.username == ^username,
      select: %{username: users.username, email: users.email, id: users.id},
      limit: 1
  end
end
