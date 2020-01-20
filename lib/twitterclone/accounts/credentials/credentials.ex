defmodule Twitterclone.Accounts.Credentials do

  alias Twitterclone.Accounts.Credentials.Credential

  def cast_assoc_credentials(user) do
    user |> Ecto.Changeset.cast_assoc(:credential, with: &Credential.changeset/2)
  end

  def update_credentials() do

  end

end
