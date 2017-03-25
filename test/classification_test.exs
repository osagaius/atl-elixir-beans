defmodule Beans.ClassificationTest do
  use ExUnit.Case

  @classification_filename "beans_names_and_classifications.csv"
  @classification_file_path "priv/data/#{@classification_filename}"

  setup do
    Beans.Classification.start_link

    {:ok, %{}}
  end

  test "build_store/0", context do
    Beans.Classification.build_store
    pid = Process.whereis(Beans.Classification)
    {:messages, messages} = Process.info(pid, :messages)

    valid_messages = messages
    |> Enum.filter(fn{k, v} ->
      k == :"$gen_cast" && v |> elem(0) == :build_store
    end)

    assert valid_messages |> Enum.count > 0
  end

  test "handler builds store", context do
    pid = Process.whereis(Beans.Classification)
    GenServer.cast(pid, {:build_store, [@classification_file_path]})

    #sleep for 25ms so the process handles the message
    :timer.sleep(25)

    process_store = :sys.get_state(pid) |> Map.get(:store, [])
    assert process_store |> Map.keys |> Enum.count > 0
  end


end
