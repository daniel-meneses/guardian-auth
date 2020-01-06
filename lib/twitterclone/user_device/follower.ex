defmodule Twitterclone.Followers.Follower do
  use Ecto.Schema
  import Ecto.Changeset

  alias Twitterclone.Accounts.User
  alias Twitterclone.Followers.Follower

  @type t :: %__MODULE__{
          id: integer,
          accepted: Boolean.t(),
          user_id: integer,
          subject_id: integer,
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  @required_fields ~w(accepted)a

  embedded_schema do
    field :accepted, :boolean
    belongs_to :user, User
    belongs_to :subject, User
    timestamps()
  end

  @doc false
  def changeset(%Follower{} = follower, attrs) do
    follower
    |> cast(attrs, [:user_id, :subject_id])
    |> validate_required([:user_id, :subject_id])
    |> foreign_key_constraint(:subject_id)
    |> unique_constraint(:unique_subscription, name: :unique_subscription_index)
  end
end
