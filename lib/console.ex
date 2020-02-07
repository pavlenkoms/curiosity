defmodule Curiosity.Console do
  alias Curiosity.API

  def from_file(path) do
    path
    |> API.from_file()
    |> process_result()
  end

  def from_string(string) do
    string
    |> API.from_string()
    |> process_result()
  end

  def from_list(list) do
    list
    |> API.from_list()
    |> process_result()
  end

  def from_file_async(path) do
    API.from_file_async(path)
  end

  def from_string_async(string) do
    API.from_string_async(string)
  end

  def from_list_async(list) do
    API.from_list_async(list)
  end

  def await(ref, timeout \\ 5000) do
    ref
    |> API.await(timeout)
    |> process_result()
  end

  defp process_result({:ok, result}) when is_map(result), do: result[:summary]
  defp process_result({:error, _} = err), do: err
  defp process_result(err), do: {:error, {:unknown_error, err}}
end
