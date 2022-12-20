defmodule AuthIntroduct.Support.Auth do
  @moduledoc false
  def get_user(_id) do
    %{email: "foo4@bar.com", id: 44, password_hash: "$2b$12$16DBHTrQYre2Ucc6IZDBEu9NmwpMopA/5uR26Aa2wLxmF/VQDtKku", role_id: 1}
  end

  def get_role(_role_id) do
    "user"
  end

  def get_user_claims(_user) do
    %{"sub" => 44, "role" => "user"}
  end
end
