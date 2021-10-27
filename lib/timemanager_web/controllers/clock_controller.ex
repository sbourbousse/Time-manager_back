defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts
  alias TimeManager.Accounts.Clock

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    clocks = Accounts.list_clocks()
    render(conn, "index.json", clocks: clocks)
  end

  def indexclocks(conn, %{"userID" => userId}) do
    clocks = Accounts.list_clocks_by_user(userId)
    render(conn, "index.json", clocks: clocks)
  end

  def create(conn, %{"clock" => clock_params, "userID" => userId}) do
    clock_params_new = Map.put_new(clock_params, "user", String.to_integer(userId))
    IO.inspect(clock_params_new)
    with {:ok, %Clock{} = clock} <- Accounts.create_clock(clock_params_new) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.clock_path(conn, :show, clock))
      |> render("show.json", clock: clock)
    end
  end

  def show(conn, %{"id" => id}) do
    clock = Accounts.get_clock!(id)
    render(conn, "show.json", clock: clock)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Accounts.get_clock!(id)

    with {:ok, %Clock{} = clock} <- Accounts.update_clock(clock, clock_params) do
      render(conn, "show.json", clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = Accounts.get_clock!(id)

    with {:ok, %Clock{}} <- Accounts.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
