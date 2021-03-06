defmodule Twitterclone.Accounts.Credentials.Credential do
  use Ecto.Schema
  import Ecto.Changeset

  alias Twitterclone.Users.User
  alias Comeonin.Bcrypt

  schema "credentials" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    belongs_to :user, User
    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:email, :password, :password_confirmation])
    |> validate_required([:email, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> downcase_value
    |> put_password_hash
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}}
        -> put_change(changeset, :password_hash, Bcrypt.hashpwsalt(password))
      _ -> changeset
    end
  end

  def downcase_value(changeset) do
    update_change(changeset, :email, &String.downcase/1)
  end

end
