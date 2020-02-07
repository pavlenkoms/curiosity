defmodule Curiosity.SpawnerTest do
  use ExUnit.Case, async: false

  alias Curiosity.{Spawner, Processor}

  import Mock

  test "async succes" do
    with_mock Processor,
      process: fn _ ->
        :timer.sleep(100)
        :success
      end do
      ref = Spawner.async("some")
      assert :success == Spawner.await(ref, 500)
    end
  end

  test "async timeout" do
    with_mock Processor,
      process: fn _ ->
        :timer.sleep(100)
        :success
      end do
      ref = Spawner.async("some")
      assert {:error, :timeout} == Spawner.await(ref, 50)
    end
  end

  test "sync succes" do
    with_mock Processor,
      process: fn _ ->
        :timer.sleep(100)
        :success
      end do
      assert :success == Spawner.sync("some")
    end
  end

  test "sync timeout" do
    with_mock Processor,
      process: fn _ ->
        :timer.sleep(100)
        :sucess
      end do
      assert {:error, :timeout} == Spawner.sync("some", 50)
    end
  end
end
