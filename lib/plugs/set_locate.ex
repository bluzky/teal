defmodule Teal.Plug.SetLocale do
  import Plug.Conn

  def init(opts), do: opts

  @doc """
  suported options:
  default_locale : default locale in case no locale is set
  backends: list of backend to update locale 
  """
  def call(conn, opts) do
    default_locale = Keyword.get(opts, :default_locale, "en")
    backends = Keyword.get(opts, :backends, [])
    user = conn.assigns[:current_user] || %{}

    locale =
      conn
      |> get_req_header("x-language")
      |> List.first()

    locale = locale || Map.get(user, :locale, default_locale)

    Enum.each(backends, fn item -> Gettext.put_locale(item, locale) end)

    conn
    |> assign(:locale, locale)
  end
end
