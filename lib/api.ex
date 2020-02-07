defmodule Curiosity.API do
  alias Curiosity.{Input, Spawner}

  def from_file(path) do
    Input.from_file(path)
  end

  def from_string(string) do
    Input.from_string(string)
  end

  def from_list(list) do
    Input.from_list(list)
  end

  def from_file_async(path) do
    Input.from_file(path, false)
  end

  def from_string_async(string) do
    Input.from_string(string, false)
  end

  def from_list_async(list) do
    Input.from_list(list, false)
  end

  def await(ref, timeout \\ 5000) do
    Spawner.await(ref, timeout)
  end
end
