defmodule Curiosity.ProcessorTest do
  use ExUnit.Case, async: false

  alias Curiosity.Processor

  test "sucess" do
    assert {:ok,
            %{
              :amount_of_out_lines => 1,
              :size => 3,
              :summary => "(1, 1 score:45)",
              {0, 0} => 12,
              {1, 1} => 45,
              {2, 2} => 28,
              {0, 1} => 27,
              {0, 2} => 24,
              {1, 0} => 21,
              {1, 2} => 39,
              {2, 0} => 16,
              {2, 1} => 33
            }} == Processor.process([1, 3, 1, 2, 3, 4, 5, 6, 7, 8, 9])
  end

  test "sucess from task 1" do
    {:ok, %{summary: "(3, 3 score:26)"}} = Processor.process([1, 5, 5, 3, 1, 2, 0, 4, 1, 1, 3, 2, 2, 3, 2, 4, 3, 0, 2, 3, 3, 2, 1, 0, 2, 4, 3])
  end

  test "sucess from task 2" do
    {:ok, %{summary: "(1, 2 score:27)\n(1, 1 score:25)\n(2, 2 score:23)"}} = Processor.process([3, 4, 2, 3, 2, 1, 4, 4, 2, 0, 3, 4, 1, 1, 2, 3, 4, 4])
  end
end
