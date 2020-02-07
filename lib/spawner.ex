defmodule Curiosity.Spawner do
  alias Curiosity.Processor

  def start_link do
    Task.Supervisor.start_link(name: __MODULE__)
  end

  def async(input_data) do
    Task.Supervisor.async_nolink(
      __MODULE__,
      fn -> process(input_data) end
    )
  end

  # It's horrible, but Task have no ability to terminate some one or return timeout without EXIT, and I
  # so my way is possible for small projects like this, but not for big ones, for bigger things I will search something else
  def await(%Task{ref: ref, pid: pid} = _task, timeout \\ 5000) do
    receive do
      {^ref, reply} ->
        Process.demonitor(ref, [:flush])
        reply

      {:DOWN, ^ref, _, _proc, reason} ->
        {:error, {:worker_down_with_reason, reason}}
    after
      timeout ->
        Process.demonitor(ref, [:flush])
        Process.exit(pid, :kill)
        {:error, :timeout}
    end
  end

  def sync(input_data, timeout \\ 5000) do
    ref = async(input_data)
    await(ref, timeout)
  end

  defp process(input_data) do
    Processor.process(input_data)
  end
end
