defmodule AuthIntroduct.User do
  alias AuthIntroduct.JwtGenerateEmptyParams
  def validate_user(user_id, sub, resource, role, resource_role) do
    if user_id == sub && sub == resource.id && role == resource_role do
      {:ok, :authorized}
    else
      {:error, :unauthorized}
    end
  end

  def validate_claims!(claims) do
    if claims != nil && Map.has_key?(claims, :role) && Map.has_key?(claims, :sub) do
      {:ok, claims}
    else
      {:error, %JwtGenerateEmptyParams{}}
    end
  end
end
