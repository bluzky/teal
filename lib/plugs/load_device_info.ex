defmodule Teal.Plug.LoadDeviceInfo do
  import Plug.Conn
  alias Teal.Helpers

  def init(default), do: default

  @doc """
  supported options:
  supported_platforms: list of supported platform
  """
  def call(conn, opts) do
    headers = conn.assigns[:headers] || %{}
    device_type = headers["x-device-type"]
    device_unique_id = headers["x-device-id"]
    device_name = headers["x-device-name"]

    with {:ok, device_type} <- validate_device_type(device_type, opts),
         {:ok, device_unique_id} <- validate_device_unique_id(device_unique_id) do
      conn
      |> assign(:device_id, device_unique_id)
      |> assign(:device_type, device_type)
      |> assign(:device_name, device_name)
    else
      {:error, :request_invalid, err} ->
        conn
        |> put_status(:bad_request)
        |> Helpers.send_json(err)
        |> halt()
    end
  end

  defp validate_device_type(device_type, opts) do
    supported_platforms = Keyword.get(opts, :supported_platforms)

    if device_type in supported_platforms do
      {:ok, device_type}
    else
      {:error, :request_invalid,
       %{
         status: "DEVICE_TYPE_REQUIRED",
         message: "Device type is required"
       }}
    end
  end

  defp validate_device_unique_id(device_unique_id) do
    if is_nil(device_unique_id) do
      {:error, :request_invalid,
       %{
         status: "DEVICE_ID_REQUIRED",
         message: "Device id is required"
       }}
    else
      {:ok, device_unique_id}
    end
  end
end
