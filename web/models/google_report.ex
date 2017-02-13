defmodule Talky.GoogleReport do
  use Talky.Web, :model
  alias Talky.Repo

  schema "google_reports" do
    field :view_name
    field :view_id, :integer
    field :metric
    field :dimension
    field :value
    field :created_date, :date
    field :updated_at, :utc_datetime
  end

  def clear_records(view_id, metric, created_date) do
    from( g in Talky.GoogleReport, where: [
      view_id: ^view_id, metric: ^metric, created_date: ^created_date
    ]) |> Repo.delete_all
  end

  def insert_records(
    view_name, view_id, metric, created_date, data
  ) do
    report = List.first(data["reports"])

    if report && report["data"]["rows"] &&
       length(report["data"]["rows"]) > 0
    do
      Repo.insert_all(Talky.GoogleReport,
        for(row <- report["data"]["rows"]) do
          m = row["metrics"] |> List.first
          if m do
            %{
              view_name: view_name,
              view_id: view_id,
              metric: metric,
              dimension: row["dimensions"] |> List.first,
              value: m["values"] |> List.first,
              created_date: created_date,
              updated_at:  DateTime.utc_now()
            }
          end
        end
      )
    end
  end
end

