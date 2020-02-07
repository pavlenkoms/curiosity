defmodule Curiosity do
  use Application
  import Supervisor.Spec

  def start(_type, _args) do
    children = [
      supervisor(Curiosity.Spawner, [])
    ]

    opts = [strategy: :one_for_one, name: Curiosity.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
