defmodule Teal.GoogleHeler do
  require Logger
  @profile_endpoint "https://www.googleapis.com/oauth2/v3/userinfo"

  def get(url, params) do
    query = URI.encode_query(params)
    HTTPoison.get("#{url}?#{query}")
  end

  def get_profile(access_token) do
    get(@profile_endpoint, access_token: access_token)
    |> handle_response
  end

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    case Jason.decode(body) do
      {:error, err} ->
        Logger.error(inspect(err))
        {:error, err}

      {:ok, data} ->
        {:ok, parse_profile(data)}
    end
  end

  defp handle_response({:ok, %{body: body} = resp}) do
    Logger.error(inspect(body))
    {:error, body}
  end

  defp handle_response({:error, _} = err), do: err

  defp parse_profile(json) do
    %{
      email: json["email"],
      first_name: json["given_name"],
      last_name: json["family_name"],
      name: json["name"],
      email_verified: json["email_verified"],
      avatar: json["picture"],
      identifier: json["sub"],
      locale: json["locale"]
    }
  end
end
