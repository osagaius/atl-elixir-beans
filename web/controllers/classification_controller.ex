defmodule Beans.ClassificationController do
  use Beans.Web, :controller

  def get_classification(conn, params) do
    %{resp_headers: resp_headers} = conn
    conn = %{conn| resp_headers: [{"content-type", "application/json"}|resp_headers]}

    case Beans.Classification.get_classification(params["bean_name"]) do
      {:ok, classification} ->
        resp_body = %{"classification" => classification}
        send_resp(conn, 200, Poison.encode!(resp_body))
      _ ->
        resp_body = %{"error" => "Unable to locate classification for specified bean."}
        send_resp(conn, 404, Poison.encode!(resp_body))
    end
  end

  def add_bean_classification(conn, params) do
    %{resp_headers: resp_headers} = conn
    conn = %{conn| resp_headers: [{"content-type", "application/json"}|resp_headers]}

    send_resp(conn, 404, %{"error" => "Invalid bean name"} |> Poison.encode!)
  end
end
