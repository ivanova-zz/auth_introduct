defmodule AuthIntroduct.User do
  def validate_user(user_id, sub, resource, role, resource_role) do
    if user_id == sub && sub == resource.id && role == resource_role do
      {:ok, :authorized}
    else
      {:error, :unauthorized}
    end
  end
end
