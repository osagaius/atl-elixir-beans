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

    {status, resp_body} = cond do
      is_nil(params["bean_name"]) ->
        {404, %{"error" => "Invalid bean name"}}
      is_nil(params["classification"]) ->
        {404, %{"error" => "Invalid classification"}}
      true ->
        Beams.Classification.add_bean(params["bean_name"], params["classification"])
        {200, %{"success" => "True"}}
    end

    send_resp(conn, status, resp_body |> Poison.encode!)
  end
end
