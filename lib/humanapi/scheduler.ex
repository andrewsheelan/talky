defmodule Talky.Humanapi.Scheduler do
  alias Talky.Humanapi.Source
  use Timex

  def fetch_all do
    humen = Talky.Repo.all(Talky.Human)
    limit = 3
    for human <- humen do
      start_time = Duration.now
      response   = HTTPotion.get "https://api.humanapi.co/v1/human/activities/summaries",
                 query: %{access_token: human.access_token, limit: limit}
      activities = Poison.decode!(response.body, as: [%Source{}])
                   |> Enum.map(fn x -> %{source: x.source, steps: x.steps, duration: x.duration/60, calories: ( x.calories), date: x.date} end)
                   |> Enum.group_by(fn x -> x.date end, fn x -> x end)
      for {k, x} <- activities do
        duration = Enum.reduce(x, 0, fn(d, acc) -> d.duration + acc end)
        steps    = Enum.reduce(x, 0, fn(d, acc) -> d.steps + acc end)
        calories = round(Enum.reduce(x, 0, fn(d, acc) -> d.calories + acc end))
        IO.puts("#{human.user_id} #{k} #{duration} #{steps} #{calories}")
        end_time = Duration.now
        IO.puts("Operation took -- #{Duration.diff(end_time, start_time, :milliseconds)} milliseconds")
      end
      nil
    end
  end
end

