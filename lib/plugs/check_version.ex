defmodule HrApi.Plug.CheckVersion do
  import Plug.Conn
  import Phoenix.Controller
  require Logger

  def init(default), do: default

  def call(conn, _default) do
    version =
      conn
      |> get_req_header("x-app-version")
      |> List.first()

    device_type = conn.assigns[:device_type]

    if is_version_suported(device_type, version) do
      conn
      |> assign(:version, version)
    else
      conn
      |> put_view(HrApi.ErrorView)
      |> render("version_update_required.json")
      |> halt()
    end
  end

  defp is_version_suported(platform, version) do
    supported_version = get_supported_version(platform)
    :verl.is_match(version || "", ">=#{supported_version}")
  end

  defp get_supported_version(platform) do
    case platform do
      "android" ->
        System.get_env("YEAH1_APP_ANDROID_VERSION")

      "ios" ->
        System.get_env("YEAH1_APP_IOS_VERSION")

      _ ->
        "0.0.0"
    end
  end
end
