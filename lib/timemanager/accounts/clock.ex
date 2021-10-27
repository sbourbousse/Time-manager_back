defmodule TimeManager.Accounts.Clock do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]


  schema "clocks" do
    field :status, :boolean, default: false
    field :time, :naive_datetime
    field :user, :id

    timestamps()
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:time, :status, :user])
    |> validate_required([:time, :status, :user])
  end

  def getByUserId(query, userId) do
    from clocks in query,
    where: clocks.user == ^userId,
    select: %{status: clocks.status, time: clocks.time, id: clocks.id}
  end
end
