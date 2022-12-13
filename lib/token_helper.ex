defmodule AuthIntroduct.TokenHelper do
  use Joken.Config
  alias AuthIntroduct.EmptyParam

  def get_token(headers) do
    Enum.reduce(headers, [], fn({k,v}, acc) ->
      if k == "authorization" do
        acc ++ v
      else
        acc
      end
    end)
    |> String.split(" ")
    |> List.last
  end

  def get_module(mod) do
    mod
    |> Tuple.to_list
    |> List.last
    |> Enum.reduce("Elixir", fn(x, acc) -> acc <> "." <> Atom.to_string(x) end)
    |> String.to_atom
  end

  def create_signer(secret) do
    Joken.Signer.create("HS512", secret)
  end

  def token_config(aud, iss) do
    default_claims(default_exp: 31_537_000, aud: to_string(aud), iss: to_string(iss))
  end

  def verify_jwt(token, secret, aud, iss) do
    signer = create_signer(secret)

#    token_config(aud, iss)
#    |> Joken.verify_and_validate(token, signer)
    conf = token_config(aud, iss)
    ans = Joken.verify_and_validate(conf, token, signer)
    IO.puts("ans: #{inspect ans}")
    IO.puts("signer: #{inspect signer}")
    IO.puts("token: #{inspect token}")
    IO.puts("aud: #{inspect aud}")
    IO.puts("iss: #{inspect iss}")
    IO.puts("conf: #{inspect conf}")
    ans
  end

  def generate_jwt!(claims, secret, aud, iss) do
    signer = create_signer(secret)

    {:ok, token, _claims} =
      token_config(aud, iss)
      |> Joken.generate_and_sign(claims, signer)

    token
  end

  def get_jwt_param(jwt_body, key) do
    {:ok, param} = Map.fetch(jwt_body, key)
    if param do
      {:ok, param}
    else
      {:invalid_payload, %EmptyParam{}}
    end
  end
end
