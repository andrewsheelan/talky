defmodule Talky.Humanapi.Scheduler do
  alias Talky.Humanapi.Source
  use Timex

  def sync do
    humen = Talky.Repo.all(Talky.Human)
    Task.Supervisor.start_link(name: :task_supervisor)
    for human <- humen do
      Task.Supervisor.async_nolink(:task_supervisor, fn -> fetch(human) end)
      nil
    end
    IO.puts(" Operation started for #{length(humen)} records")
  end

  def fetch(human) do
    limit = 3
    start_time = Duration.now
    response   = HTTPotion.get "https://api.humanapi.co/v1/human/activities/summaries",
                                query: %{access_token: human.access_token, limit: limit}
    activities = Poison.decode!(response.body, as: [%Source{}])
                   |> Enum.map(fn x ->
                        %{
                            source: x.source,
                            steps: x.steps,
                            duration: x.duration/60,
                            calories:  (x.sourceData["activityCalories"] || x.calories),
                            date: x.date
                        }
                    end)
                   |> Enum.group_by(fn x -> x.date end, fn x -> x end)
    for {assigned_date, details} <- activities do
        duration = Enum.reduce(details, 0, fn(d, acc) -> d.duration + acc end)
        Talky.DeviceActivity.insert_record(human.user_id, assigned_date, duration, details)
    end
    end_time = Duration.now
    IO.puts("For user #{human.user_id} took -- #{Duration.diff(end_time, start_time, :milliseconds)}ms")
  end
end

