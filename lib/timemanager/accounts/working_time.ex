defmodule TimeManager.Accounts.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]


  schema "workingtimes" do
    field :end, :naive_datetime
    field :start, :naive_datetime
    field :user, :id

    timestamps()
  end

  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:start, :end, :user])
    |> validate_required([:start, :end, :user])
  end

  def getByUsernameAndEmail(query, userId, startDT, endDT) do
    from workingtimes in query,
    where: workingtimes.start >= ^startDT and workingtimes.end <= ^endDT and workingtimes.user == ^userId,
    select: %{start: workingtimes.start, end: workingtimes.end, id: workingtimes.id}
  end
end
