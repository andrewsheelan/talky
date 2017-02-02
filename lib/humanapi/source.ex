defmodule Talky.Humanapi.Source do
  @derive [Poison.Encoder]
  defstruct [
    :id, :humanId, :light, :moderate, :sedentary, :source,
    :sourceData, :userId, :vigorous, :date, :steps, :duration,
    :calories, :createdAt, :updatedAt
  ]
end
