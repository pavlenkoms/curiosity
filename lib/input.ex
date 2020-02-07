defmodule Curiosity.Input do
  alias Curiosity.Spawner

  def from_file(file_path, sync \\ true)

  def from_file(file_path, sync) when is_bitstring(file_path) do
    with {:ok, data} <- File.read(file_path),
         {:ok, list} <- parse_data(data) do
      if sync do
        Spawner.sync(list)
      else
        Spawner.async(list)
      end
    end
  end

  def from_file(_file_path, _sync) do
    {:error, :bad_file_path}
  end

  def from_string(string, sync \\ true)

  def from_string(string, sync) when is_bitstring(string) do
    with {:ok, list} <- parse_data(string) do
      if sync do
        Spawner.sync(list)
      else
        Spawner.async(list)
      end
    end
  end

  def from_string(_string, _sync) do
    {:error, :input_should_be_a_string}
  end

  def from_list(list, sync \\ true)

  def from_list([_ | _] = list, sync) do
    if sync do
      Spawner.sync(list)
    else
      Spawner.async(list)
    end
  end

  def from_list(_list, _sync) do
    {:error, :input_should_be_non_empty_list}
  end

  defp parse_data(data) do
    data
    |> String.split()
    |> Enum.reduce_while([], fn el, acc ->
      case Integer.parse(el) do
        :error -> {:halt, :error}
        {num, _} -> {:cont, [num | acc]}
      end
    end)
    |> case do
      [_ | _] = list ->
        {:ok, Enum.reverse(list)}

      _ ->
        {:error, :bad_data_format}
    end
  end
end
