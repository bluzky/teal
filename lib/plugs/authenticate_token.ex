defmodule Teal.Plug.AuthenticateToken do
  import Plug.Conn
  require Logger
  alias Teal.Helpers

  @moduledoc false

  def init(default), do: default

  @doc """
  support options:
  guardian_module [required]: guardian authentication module

  """
  def call(conn, default) do
    guardian_module = Keyword.get(default, :guardian_module)

    if not is_atom(guardian_module) do
      raise ArgumentError, "missing argument :guardian_module"
    end

    token = get_in(conn.assigns, [:headers, "x-access-token"])

    with false <- is_nil(token),
         {:ok, user, claims} <- guardian_module.resource_from_token(token) do
      conn
      |> assign(:auth, %{token: token, user: user, claims: claims})
    else
      {:error, reason} ->
        Logger.error("#{inspect(reason)}")

        unauthorize(conn)

      _ ->
        unauthorize(conn)
    end
  end

  def unauthorize(conn) do
    conn
    |> put_status(:unauthorized)
    |> Helpers.send_json(%{status: "UNAUTHORIZED", message: "Token is in valid"})
    |> halt()
  end
end
