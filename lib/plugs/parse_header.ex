defmodule Teal.Plug.ParseHeader do
  def init(default), do: default

  def call(conn, _opts) do
    headers =
      conn.req_headers
      |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
      |> Enum.map(fn {key, values} ->
        {key, Enum.find(values, &(not is_nil(&1)))}
      end)
      |> Enum.into(%{})

    Plug.Conn.assign(conn, :headers, headers)
  end
end
