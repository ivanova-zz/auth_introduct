defmodule AuthIntroduct do
  import Plug.Conn
  alias AuthIntroduct.TokenHelper
  alias AuthIntroduct.Config
  alias AuthIntroduct.User

  defmacro __using__(options) do
    behaviour = TokenHelper.get_module(Keyword.get(options, :module))
    aud = Keyword.get(options, :aud)
    iss = Keyword.get(options, :iss)
    quote do
      alias unquote(behaviour), as: Mod

      @aud unquote(aud)
      @iss unquote(iss)
      @default_secret_key "HnzeaRD8Gv2HwRmZZBtcJf8aJaJFt4PoDpcdcfAXIzm0jDJeKHtQEIH1cL//n7kg"
      def call(conn, options) do
        with token <- TokenHelper.get_token(conn.req_headers),
             secret_key <- Config.get_secret_key,
             {:ok, jwt_body} <- TokenHelper.verify_jwt(token, secret_key, @aud, @iss),
             {:ok, sub} <- TokenHelper.get_jwt_param(jwt_body, "sub"),
             {:ok, role} <- TokenHelper.get_jwt_param(jwt_body, "role"),
             user <- Mod.get_user(conn.body_params[options[:key]]),
             answer <- User.validate_user(conn.body_params[options[:key]], sub, user, role, Mod.get_role(user.role_id))
          do
          if {:ok, :authorized} == answer do
            conn
          else
            conn |> resp(401, "unauthorized") |> halt()
          end
        else
          e -> conn |> resp(401, "#{inspect e}") |> halt()
        end
      end

      def generate_token(conn, opt) do
        TokenHelper.generate_jwt!(opt, Config.get_secret_key, @aud, @iss)
      end
    end
  end
end
