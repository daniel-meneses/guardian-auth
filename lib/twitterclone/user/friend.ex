defmodule Twitterclone.User.Friend do
  use Ecto.Schema
  import Ecto.Changeset
  
  alias Twitterclone.User.Friend


  schema "friends" do
    field :accepted, :boolean, default: false
    field :user_a_id, :integer
    field :user_b_id, :integer

    timestamps()
  end

  @doc false
  def changeset(friend, attrs) do
    friend
    |> cast(attrs, [:user_a_id, :user_b_id, :accepted])
    |> validate_required([:user_a_id, :user_b_id, :accepted])
  end

  def create_friend(attrs \\ %{}, user) do
    %Friend{user_a_id: user.id, user_b_id: attrs.user_id, accepted: false}
    |> Friend.changeset(attrs)
    |> Repo.insert()
  end
end
