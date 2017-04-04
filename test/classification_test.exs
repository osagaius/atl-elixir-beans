defmodule Beans.ClassificationTest do
  use ExUnit.Case

  @classification_filename "beans_names_and_classifications.csv"
  @classification_file_path "priv/data/#{@classification_filename}"

  setup do
    Beans.Classification.start_link

    {:ok, %{}}
  end

  test "store is built", context do
    pid = Process.whereis(Beans.Classification)

    process_store = :sys.get_state(pid) |> Map.get(:store, [])
    assert process_store |> Map.keys |> Enum.count > 0
  end

  test "increments counter for bean name", context do
    pid = Process.whereis(Beans.Classification)

    bean_name = "test_bean"
    Beans.Classification.get_classification(bean_name)
    process_counters = :sys.get_state(pid) |> Map.get(:counters)
    assert process_counters |> Map.get(bean_name) == 1
  end


end
