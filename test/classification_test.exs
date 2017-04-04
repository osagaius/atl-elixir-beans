defmodule Beans.ClassificationTest do
  use ExUnit.Case

  @classification_filename "beans_names_and_classifications.csv"
  @classification_file_path "priv/data/#{@classification_filename}"

  setup do
    Beans.Classification.start_link

    {:ok, %{}}
  end

  test "store is built", context do
    assert Beans.Classification.get_classification("pinto") == {:ok, "phaseolus"}
  end


end
