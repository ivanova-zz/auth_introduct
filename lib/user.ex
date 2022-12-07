defmodule AuthIntroduct.User do
  def validate_user_id(user_id, sub, resource) do
    if user_id == sub && sub == resource.id do
      {:ok, :authorized}
    else
      {:error, :unauthorized}
    end
  end
  
end
