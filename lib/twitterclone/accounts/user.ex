defmodule Twitterclone.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  alias Twitterclone.Accounts.User

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    has_many :user_subscriptions, Twitterclone.User.Subscription, foreign_key: :user_id, references: :id
    has_many :posts, Twitterclone.User.Post, foreign_key: :user_id, references: :id
    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    # casting for external data validations
    |> cast(attrs, [:first_name, :last_name, :email, :password, :password_confirmation])
    |> validate_required([:first_name, :last_name, :email, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 8)
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> put_password_hash
  end

  # Private method for adding hashed password
  @doc false
  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}}
        ->
          # put_change for internal data changes. no validations needed.
          put_change(changeset, :password_hash, hashpwsalt(password))
      _ ->
          changeset
    end
  end

end
