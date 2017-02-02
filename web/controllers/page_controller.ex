defmodule Talky.PageController do
  use Talky.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
