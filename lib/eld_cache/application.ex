defmodule EldCache.Application do
  use Application

  def start(_type, _args) do
    children = [
      {EldCache.Cache, []}
    ]
    opts = [strategy: :one_for_one, name: EldCache.Application]
    Supervisor.start_link(children, opts)
  end
end
