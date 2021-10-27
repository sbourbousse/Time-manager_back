defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.Accounts
  alias TimeManager.Accounts.WorkingTime

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, _params) do
    workingtimes = Accounts.list_workingtimes()
    render(conn, "index.json", workingtimes: workingtimes)
  end

  def create(conn, %{"working_time" => working_time_params, "userID" => userId}) do
    working_time_params_new = Map.put_new(working_time_params, "user", String.to_integer(userId))
    with {:ok, %WorkingTime{} = working_time} <- Accounts.create_working_time(working_time_params_new) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.working_time_path(conn, :show, working_time))
      |> render("show.json", working_time: working_time)
    end
  end

  def show(conn, %{"id" => id}) do
    working_time = Accounts.get_working_time!(id)
    render(conn, "show.json", working_time: working_time)
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = Accounts.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- Accounts.update_working_time(working_time, working_time_params) do
      render(conn, "show.json", working_time: working_time)
    end
  end

  def indexperiod(conn, %{"userID" => userId, "start" => startDT, "end" => endDT}) do
    workingtimes = Accounts.get_working_time_list_period(userId, startDT, endDT);
    render(conn, "index.json", workingtimes: workingtimes)
  end

  def delete(conn, %{"id" => id}) do
    working_time = Accounts.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Accounts.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
