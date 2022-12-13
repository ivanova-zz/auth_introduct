defmodule AuthIntroduct do
  import Plug.Conn
  import AuthIntroduct.TokenHelper
  import AuthIntroduct.Config
  import AuthIntroduct.User

  defmacro __using__(options) do
    IO.puts("options in using: #{inspect options}")
    behaviour = get_module(Keyword.get(options, :module))
    aud = Keyword.get(options, :aud)
    iss = Keyword.get(options, :iss)
    quote do
      alias unquote(behaviour), as: Mod

      @aud unquote(aud)
      @iss unquote(iss)
      IO.puts("caller: #{inspect __CALLER__.module}}")
      def call(conn, options) do
        try do
          user_id = conn.body_params[options[:key]]
          token = get_token(conn.req_headers)
          IO.puts("authorization: #{inspect token}")
          IO.puts("options_call: #{inspect options}")
          secret_key = get_secret_key
          IO.puts("secret_key: #{inspect secret_key}")
          {:ok, jwt_body} = verify_jwt(token, secret_key, @aud, @iss)
          IO.puts("verify_jwt: #{inspect jwt_body}")
          {:ok, sub} = Map.fetch(jwt_body, "sub")
          {:ok, role} = Map.fetch(jwt_body, "role")

          IO.puts("sub: #{inspect sub}")
          user = Mod.get_user(user_id)
          answer = validate_user(user_id, sub, user, role, Mod.get_role(user.role_id))
          IO.puts("validate_user: #{inspect answer}")
          if {:ok, :authorized} == answer do
            conn
          else
            conn |> resp(401, "unauthorized") |> halt()
          end
        rescue
           e -> e
        end
      end

      def generate_token(conn, opt) do
        generate_jwt!(opt, get_secret_key, @aud, @iss)
      end
    end
  end
end
