defmodule Teal.Helpers do
  alias Plug.Conn

  def send_resp(conn, content_type, data) do
    conn
    |> Conn.put_resp_header("content-type", content_type)
    |> Conn.send_resp(conn.status || 200, data)
  end

  def send_json(conn, data) when is_map(data) do
    send_resp(conn, "application/json", Jason.encode!(data))
  end
end
