defmodule Beans do
  use Application
  require Logger

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Install Mnesia Database
    mnesia_path = Path.join([System.cwd(), "Mnesia.#{node()}"])
    db = Beans.Db
    case File.exists?(mnesia_path) do
      false ->
        Logger.warn("Installing database...")
        Amnesia.stop()
        Amnesia.Schema.create
        Amnesia.start
        try do
          db.create!([disk: [node()]])
          :ok = db.wait(15000)
        after
          Amnesia.stop
        end
        Amnesia.start()
      true ->
        Amnesia.start()
    end

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      worker(Beans.Classification, []),
      supervisor(Beans.Endpoint, []),
      # Start your own worker by calling: Beans.Worker.start_link(arg1, arg2, arg3)
      # worker(Beans.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Beans.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Beans.Endpoint.config_change(changed, removed)
    :ok
  end
end
