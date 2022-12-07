defmodule AuthIntroduct.Config do
  def get_secret_key do
    Envar.get("SECRET_KEY", Application.fetch_env!(:auth_introduct, :secret_key))
  end
end
