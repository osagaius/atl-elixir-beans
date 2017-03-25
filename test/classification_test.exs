defmodule Beans.ClassificationTest do
  use ExUnit.Case

  test "classification store is built", context do
    Beans.Classification.build_store
    pid = Process.whereis(Beans.Classification)
    process_store = :sys.get_state(pid) |> Map.get(:store, [])
    assert process_store |> Map.keys |> Enum.count > 0
  end

end
