defmodule AuthIntroductTest do
  use ExUnit.Case, async: true
  use Plug.Test
  alias AuthIntroduct.Support.Auth


  doctest AuthIntroduct

  defmodule DemoPlug do
#    use Plug.Builder

    use AuthIntroduct, key: "user", module: AuthIntroduct.Support.Auth, aud: "user_service", iss: "user_service"

    def init(opt) do
      opt
    end

    def call(conn, options) do
      AuthIntroduct.call(conn, options)
    end
  end

  defmodule DemoPipeline do
    use Plug.Builder
    plug DemoPlug, key: "user"

    plug(:index)
    def index(conn, _opts), do: send_resp(conn, 200, "OK")
  end
  setup do
    jwt = DemoPlug.generate_token(nil, Auth.get_user_claims("test"))
    {:ok, %{jwt: jwt}}
  end

  describe "call" do
    test "call plug", %{jwt: jwt} do
      conn =
        conn(:post, "/api/list", %{user: 44})
        |> put_req_header("authorization", "Bearer #{jwt}")
        |> DemoPipeline.call([key: "user"])
      assert conn.status == 200
    end
  end

  describe "generate JWT" do
    test "positive test" do
      jwt = DemoPlug.generate_token(nil, Auth.get_user_claims("test"))
      assert jwt != nil
    end
  end
end
