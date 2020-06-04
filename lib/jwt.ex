defmodule Teal.JWT.Token do
  use Joken.Config

  @issuer "my iss"
  @ttl 1000

  @impl true
  def token_config do
    config = Application.get_env(:teal, :jwt)
    ttl = Keyword.get(config, :ttl, 86400)

    %{}
    |> add_claim("iat", fn -> epoch_now() end, &(epoch_now() > &1))
    |> add_claim("eat", fn -> epoch_now() end, &(epoch_now() < &1))
  end

  defp epoch_now() do
    DateTime.now()
    |> DateTime.to_unix()
  end
end

defmodule Teal.JWT do
  alias Teal.JWT.Token

  defp get_signer() do
    config = Application.get_env(:teal, :jwt)
    alg = Keyword.get(config, :alg, "HS256")
    key = Keyword.get(config, :secret_key)

    if is_nil(key) do
      raise "JWT secret key is missing"
    end

    Joken.Signer.create(alg, key)
  end

  def generate(claims) do
    Joken.generate_and_sign(Token.token_config(), claims, get_signer())
  end

  def verify(token) do
    Joken.verify_and_validate(token, get_signer)
  end
end
