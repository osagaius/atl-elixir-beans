defmodule Beans.ClassificationTest do
  use ExUnit.Case

  @classification_filename "beans_names_and_classifications.csv"
  @classification_file_path "priv/data/#{@classification_filename}"

  setup do
    Beans.Classification.start_link

    {:ok, %{}}
  end

  test "handler builds store", context do
    pid = Process.whereis(Beans.Classification)
    
    process_store = :sys.get_state(pid) |> Map.get(:store, [])
    assert process_store |> Map.keys |> Enum.count > 0
  end


end
