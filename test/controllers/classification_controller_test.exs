defmodule Beans.ClassificationControllerTest do
  use Beans.ConnCase
  require Logger

  test "200 GET /api/v1/classification valid bean name", %{conn: conn} do
    pid = Process.whereis(Beans.Classification)
    process_store = :sys.get_state(pid) |> Map.get(:store, [])
    bean_name = process_store |> Map.keys |> Enum.random
    expected_class = process_store |> Map.get(bean_name)
    conn = get conn, "/api/v1/classification?bean_name=#{bean_name}"

    assert conn.status == 200
    resp_body = conn.resp_body |> Poison.decode!
    assert resp_body |> Map.has_key?("classification")
    assert resp_body |> Map.values == [expected_class]
  end

  test "404 GET /api/v1/classification missing bean name", %{conn: conn} do
    bean_name = "fake_bean"
    conn = get conn, "/api/v1/classification?bean_name=#{bean_name}"
    assert conn.status == 404
    assert conn.resp_body |> Poison.decode! |> Map.has_key?("error")
  end

  test "404 GET /api/v1/classification empty bean name", %{conn: conn} do
    bean_name = ""
    conn = get conn, "/api/v1/classification?bean_name=#{bean_name}"
    assert conn.status == 404
    assert conn.resp_body |> Poison.decode! |> Map.has_key?("error")
  end

  test "404 GET /api/v1/classification nil bean name", %{conn: conn} do
    conn = get conn, "/api/v1/classification"
    assert conn.status == 404
    assert conn.resp_body |> Poison.decode! |> Map.has_key?("error")
  end
end
