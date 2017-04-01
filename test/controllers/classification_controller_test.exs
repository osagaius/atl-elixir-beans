defmodule Beans.ClassificationControllerTest do
  use Beans.ConnCase
  require Logger

  setup do
    bean_name = "pinto"
    expected_class = "phaseolus"

    {:ok, %{
      bean_name: bean_name,
      expected_class: expected_class
    }}
  end

  test "200 GET /api/v1/classification valid bean name", context do
    pid = Process.whereis(Beans.Classification)
    process_store = :sys.get_state(pid) |> Map.get(:store, [])
    conn = get context.conn, "/api/v1/classification?bean_name=#{context.bean_name}"

    assert conn.status == 200
    resp_body = conn.resp_body |> Poison.decode!
    assert resp_body |> Map.has_key?("classification")
    assert resp_body |> Map.values == [context.expected_class]
  end

  test "404 GET /api/v1/classification missing bean name", context do
    bean_name = "fake_bean"
    conn = get context.conn, "/api/v1/classification?bean_name=#{bean_name}"
    assert conn.status == 404
    assert conn.resp_body |> Poison.decode! |> Map.has_key?("error")
  end

  test "404 GET /api/v1/classification empty bean name", context do
    bean_name = ""
    conn = get context.conn, "/api/v1/classification?bean_name=#{bean_name}"
    assert conn.status == 404
    assert conn.resp_body |> Poison.decode! |> Map.has_key?("error")
  end

  test "404 GET /api/v1/classification nil bean name", context do
    conn = get context.conn, "/api/v1/classification"
    assert conn.status == 404
    assert conn.resp_body |> Poison.decode! |> Map.has_key?("error")
  end
end
