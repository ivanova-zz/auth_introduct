defmodule AuthIntroduct do
  import Plug.Conn
  import AuthIntroduct.TokenHelper
  import AuthIntroduct.Config
  import AuthIntroduct.User

  defmacro __using__(options) do
    IO.puts("options in using: #{inspect options}")
    behaviour = get_module(Keyword.get(options, :module))
    quote do
      alias unquote(behaviour), as: Mod
      #      def init(options) do
      #        options
      #      end
      def call(conn, options) do
        user_id = conn.body_params[options[:key]]
        token = get_token(conn.req_headers)
        IO.puts("authorization: #{inspect token}")
        #        IO.puts("test_check_user: #{inspect Mod.get_user_id(user_id)}")
        IO.puts("options_call: #{inspect options}")
        secret_key = get_secret_key
        IO.puts("secret_key: #{inspect secret_key}")
        {:ok, jwt_body} = verify_jwt(token, secret_key, Keyword.get(options, :aud), Keyword.get(options, :iss))
        IO.puts("verify_jwt: #{inspect jwt_body}")
        {:ok, sub} = Map.fetch(jwt_body, "sub")
        {:ok, role} = Map.fetch(jwt_body, "role")

        IO.puts("sub: #{inspect sub}")
        answer = validate_user_id(user_id, sub, Mod.get_user_id(user_id))
        IO.puts("validate_user: #{inspect answer}")
        if {:ok, :authorized} == answer do
          conn
        else
          conn |> resp(401, "unauthorized") |> halt()
        end
      end

      def generate_token(conn, opt, aud, iss) do
        IO.puts("opt: #{inspect opt}")
        IO.puts("opt: #{inspect conn}")
        IO.puts("resp body: #{inspect conn.body_params}")
        token = generate_jwt!(opt, get_secret_key, aud, iss)
        IO.puts("token: #{inspect token}")
        token
      end
    end
  end
end
