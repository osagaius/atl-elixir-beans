defmodule Beans.PageController do
  use Beans.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
