defmodule AuthIntroductTest do
  use ExUnit.Case, async: true
  use Plug.Test
#  use AuthIntroduct, key: "user", module: AuthIntroduct.Support.Auth, aud: "user_service", iss: "user_service"
  alias AuthIntroduct.Support.Auth


  doctest AuthIntroduct

  defmodule DemoPlug do
    use Plug.Builder

    use AuthIntroduct, key: "user", module: AuthIntroduct.Support.Auth, aud: "user_service", iss: "user_service"

    plug(:index)
    defp index(conn, opts), do: send_resp(conn, 200, "OK")
  end
  setup do
#    jwt = "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoidXNlciIsInN1YiI6NDQsImF1ZCI6InVzZXJfc2VydmljZSIsImV4cCI6MTcwMjA0MTE5NiwiaWF0IjoxNjcwNTA0MTk2LCJpc3MiOiJ1c2VyX3NlcnZpY2UiLCJqdGkiOiIyc25kNWRyN3JsNjFyMWgyZmswMDAxbTMiLCJuYmYiOjE2NzA1MDQxOTZ9.oVVt9HllC4pJZQHNnms9cte7i_Au9kCA-hZMcswirFPT8eT7UrMjj08dY7t5Ej1x9cd13eAP7HekUx-JY_X8PQ"
    IO.puts("claim: #{inspect Auth.get_user_claims("test")}")
    jwt = DemoPlug.generate_token(nil, Auth.get_user_claims("test"))
    IO.puts("jwt: #{inspect jwt}")
    {:ok, %{jwt: jwt}}
  end

  describe "call" do
    test "call plug", %{jwt: jwt} do
      IO.puts("jwt: #{inspect jwt}")
      conn = conn(:post, "/", %{user: 44})
             |> put_req_header("accept", "application/json")
             |> put_req_header("authorization", "#{jwt}")
             |> DemoPlug.call([])
      assert conn == 200
    end
  end
end
