defmodule Optimalist.Application do
  @moduledoc """
  The Optimalist Application Service.

  The optimalist system business domain lives in this application.

  Exposes API to clients such as the `Optimalist.Web` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      
    ], strategy: :one_for_one, name: Optimalist.Supervisor)
  end
end
