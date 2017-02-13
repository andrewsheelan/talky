defmodule Talky.Google.Api do
  use Export.Ruby
  def call(method, params \\ []) do
    {:ok, ruby} = Ruby.start(ruby_lib: Path.expand("lib/google"))
    ruby
    |> Ruby.call("google_auth", method, params)
  end

  def requests do
    view_ids = %{
      82980236 => "NuMi Production Web",
      83031433 => "NuMi Production Mobile",
      132682969 => "SouthBeachDiet Tracker App",
      132674957 => "SouthBeachDiet Tracker Mobile"
    }
    metrics = ["ga:sessions", "ga:1dayUsers", "ga:7dayUsers", "ga:30dayUsers"]
    created_date = Timex.today
    url = "https://analyticsreporting.googleapis.com/v4/reports:batchGet"
    url = "#{url}?access_token=#{call("access_token")}"
    for {view_id, view_name} <- view_ids do
      IO.puts("Generating report for #{view_name} => #{view_id}")
      for metric <- metrics do
        data = response_for(url, view_id, metric)
        Talky.GoogleReport.clear_records(
          view_id, metric, created_date
        )
        Talky.GoogleReport.insert_records(
          view_name, view_id, metric, created_date, data
        )
        IO.puts("Completed report for #{view_name}")
      end
    end
  end

  def response_for(url, view_id, report) do
    {_, resp} = HTTPoison.post url, Poison.encode!(
      request_body(view_id, report)
    )
    Poison.decode!(resp.body)
  end

  def request_body(view_id, metric) do
    %{ reportRequests: [
      %{
        viewId: Integer.to_string(view_id),
        dateRanges: [%{
  	      startDate: "7daysAgo",
  	      endDate: "yesterday"
  	    }],
        metrics: [%{
          expression: metric
  	    }],
        dimensions: [%{
          name: "ga:date"
        }]
      }]
    }
  end
end

