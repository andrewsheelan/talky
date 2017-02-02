defmodule Talky.DeviceActivityController do
  use Talky.Web, :controller

  alias Talky.DeviceActivity

  def index(conn, _params) do
    device_activities = Repo.all(DeviceActivity)
    render(conn, "index.html", device_activities: device_activities)
  end

  def new(conn, _params) do
    changeset = DeviceActivity.changeset(%DeviceActivity{})
    info = ""
    render(conn, "new.html", changeset: changeset, info: info, device_activity: %{})
  end

  def create(conn, %{"device_activity" => device_activity_params}) do
    %{"day" => day, "month" => month, "year" => year} = device_activity_params["assigned_date"]
    assigned_date = "#{year}-#{month}-#{day}"
    details = device_activity_params["details"] |> Enum.map(fn({_,v}) -> v end)
    {duration, _} = Integer.parse(device_activity_params["duration"])
    IO.puts duration
    DeviceActivity.insert_record(
        device_activity_params["user_id"],
        assigned_date,
        duration,
        details
    )
    info = "Device activity created/updated successfully."
    changeset = DeviceActivity.changeset(%DeviceActivity{})
    render(conn, "new.html", changeset: changeset, info: info, device_activity: device_activity_params)
  end

  def show(conn, %{"id" => id}) do
    device_activity = Repo.get!(DeviceActivity, id)
    render(conn, "show.html", device_activity: device_activity)
  end

  def edit(conn, %{"id" => id}) do
    device_activity = Repo.get!(DeviceActivity, id)
    changeset = DeviceActivity.changeset(device_activity)
    render(conn, "edit.html", device_activity: device_activity, changeset: changeset)
  end

  def update(conn, %{"id" => id, "device_activity" => device_activity_params}) do
    device_activity = Repo.get!(DeviceActivity, id)
    changeset = DeviceActivity.changeset(device_activity, device_activity_params)

    case Repo.update(changeset) do
      {:ok, device_activity} ->
        conn
        |> put_flash(:info, "Device activity updated successfully.")
        |> redirect(to: device_activity_path(conn, :show, device_activity))
      {:error, changeset} ->
        render(conn, "edit.html", device_activity: device_activity, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    device_activity = Repo.get!(DeviceActivity, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(device_activity)

    conn
    |> put_flash(:info, "Device activity deleted successfully.")
    |> redirect(to: device_activity_path(conn, :index))
  end
end
