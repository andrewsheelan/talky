defmodule Talky.RabbitMQ.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(Mongo, [[name: :mongo, hostname: "10.0.132.139", database: "collection1", port: 30246, pool: DBConnection.Poolboy]]),
      worker(Talky.RabbitMQ.LogConsumer, [])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
