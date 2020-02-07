defmodule Curiosity.Processor do
  def process([_ | _] = input) do
    with {:ok, amount_of_out_lines, size, tail} <- is_input_valid?(input),
         {:ok, formatted} <- format_data(size, tail),
         {:ok, calculated} <- calculate_data(size, formatted) do
      result =
        calculated
        |> add_summary(amount_of_out_lines)
        |> Map.put(:size, size)
        |> Map.put(:amount_of_out_lines, amount_of_out_lines)

      {:ok, result}
    else
      {:error, _} = err -> err
      err -> {:error, {:unknown_error, err}}
    end
  end

  def process(_input) do
    {:error, :input_should_be_non_empty_list}
  end

  defp is_input_valid?([amount_of_out_lines, size | tail] = _input)
       when is_integer(amount_of_out_lines) and is_integer(size) and amount_of_out_lines > 0 and
              size > 0 do
    with true <-
           Enum.all?(tail, &(is_integer(&1) and &1 >= 0 and &1 < 10)) ||
             {:error, :bad_element_in_input},
         true <- size * size == Enum.count(tail) || {:error, :bad_element_number} do
      {:ok, amount_of_out_lines, size, tail}
    end
  end

  defp is_input_valid?(_input) do
    {:error, :bad_header_or_input_data_type}
  end

  defp format_data(size, tail) do
    zero_based_indexes = 0..(size - 1)
    index_list = for y <- zero_based_indexes, x <- zero_based_indexes, do: {x, y}
    zipped_data = Enum.zip(index_list, tail)
    mapped_data = for x <- zipped_data, into: %{}, do: x
    {:ok, mapped_data}
  end

  defp calculate_data(size, formatted) do
    size = size - 1

    calculated =
      formatted
      |> Enum.map(fn {{x, y}, _} ->
        min_x = if x == 0, do: 0, else: x - 1
        max_x = if x == size, do: x, else: x + 1
        min_y = if y == 0, do: 0, else: y - 1
        max_y = if y == size, do: y, else: y + 1

        keys = for yy <- min_y..max_y, xx <- min_x..max_x, do: {xx, yy}

        sum =
          Enum.reduce(keys, 0, fn key, acc ->
            acc + formatted[key]
          end)

        {{x, y}, sum}
      end)
      |> Map.new()

    {:ok, calculated}
  end

  defp add_summary(calculated, amount_of_out_lines) do
    list =
      Enum.sort(calculated, fn {_, a}, {_, b} ->
        a >= b
      end)

    {summary, _} = Enum.split(list, amount_of_out_lines)
    summary = for {{x, y}, score} <- summary, do: "(#{x}, #{y} score:#{score})"
    summary = Enum.join(summary, "\n")
    Map.put(calculated, :summary, summary)
  end
end
