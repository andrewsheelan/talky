defmodule Talky.DeviceActivity do
  use Talky.Web, :model

  schema "device_activities" do
    field :duration, {:array, :integer}
    field :details, {:array, :map}
    field :assigned_date, :date
    belongs_to :user, Talky.User

    timestamps(inserted_at: :created_at)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:duration, :details, :assigned_date])
    |> validate_required([:duration, :details, :assigned_date])
  end

  def insert_record(user_id, assigned_date, duration, details) do
    datetime = DateTime.utc_now() |> DateTime.to_iso8601()
    darray = Enum.map(1..div(duration,10), fn _ -> '10' end) |> Enum.join(",")
    duration = "{#{darray}}"
    details  = Poison.encode!(details)
    query   = """
      insert into device_activities
      (details, duration, assigned_date, user_id, created_at, updated_at)
      values('#{details}','#{duration}','#{assigned_date}','#{user_id}','#{datetime}', '#{datetime}')
      ON CONFLICT (user_id, assigned_date) DO UPDATE SET
      details='#{details}',duration='#{duration}',updated_at='#{datetime}'
    """
    Ecto.Adapters.SQL.query!(Talky.Repo, query ,[])
  end
end
