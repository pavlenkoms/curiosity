defmodule Curiosity.InputTest do
  use ExUnit.Case, async: false

  alias Curiosity.{Input, Spawner}

  import Mock

  describe "from_file test" do
    setup_with_mocks([
      {Spawner, [], [sync: fn _ -> :sync end]},
      {Spawner, [], [async: fn _ -> :async end]},
      {File, [],
       [
         read: fn
           "success" -> {:ok, "1 2 1 2 3 4"}
           "fail" -> {:error, :enoent}
         end
       ]}
    ]) do
      {:ok, %{}}
    end

    test "sync success", _ do
      assert :sync == Input.from_file("success")
    end

    test "async success", _ do
      assert :async == Input.from_file("success", false)
    end

    test "sync fail", _ do
      assert {:error, :enoent} == Input.from_file("fail")
    end

    test "async fail", _ do
      assert {:error, :enoent} == Input.from_file("fail", false)
    end

    test "bad file path fail", _ do
      assert {:error, :bad_file_path} == Input.from_file(123, false)
    end
  end

  describe "from_string test" do
    setup_with_mocks([
      {Spawner, [], [sync: fn _ -> :sync end]},
      {Spawner, [], [async: fn _ -> :async end]}
    ]) do
      {:ok, %{}}
    end

    test "sync success", _ do
      assert :sync == Input.from_string("1 2 1 2 3 4")
    end

    test "async success", _ do
      assert :async == Input.from_string("1 2 1 2 3 4", false)
    end

    test "sync fail", _ do
      assert {:error, :bad_data_format} == Input.from_string("1 2 ab 2 3 4")
    end

    test "async fail", _ do
      assert {:error, :bad_data_format} == Input.from_string("1 2 ab 2 3 4", false)
    end

    test "bad string fail", _ do
      assert {:error, :input_should_be_a_string} == Input.from_string(123, false)
    end
  end

  describe "from_list test" do
    setup_with_mocks([
      {Spawner, [], [sync: fn _ -> :sync end]},
      {Spawner, [], [async: fn _ -> :async end]}
    ]) do
      {:ok, %{}}
    end

    test "sync success", _ do
      assert :sync == Input.from_list([1, 2, 1, 2, 3, 4])
    end

    test "async success", _ do
      assert :async == Input.from_list([1, 2, 1, 2, 3, 4], false)
    end

    test "empty list fail", _ do
      assert {:error, :input_should_be_non_empty_list} == Input.from_list([], false)
    end

    test "atom fail", _ do
      assert {:error, :input_should_be_non_empty_list} == Input.from_list(:atom, false)
    end
  end
end
