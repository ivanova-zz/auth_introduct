defmodule AuthIntroduct.User do
  def validate_user_id(user_id, sub, resource, role, resource_role) do
    IO.puts("resource: #{inspect resource}}")
    IO.puts("role: #{inspect role}}")
    IO.puts("resource_role: #{inspect resource_role}}")
    if user_id == sub && sub == resource.id && role == resource_role do
      {:ok, :authorized}
    else
      {:error, :unauthorized}
    end
  end
end
