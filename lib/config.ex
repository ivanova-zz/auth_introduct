defmodule AuthIntroduct.Config do
  def get_secret_key do
    secret = Envar.get("SECRET_KEY", Application.fetch_env!(:auth_introduct, :secret_key))
    secret
  end
end
