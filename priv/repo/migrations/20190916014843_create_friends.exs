defmodule Twitterclone.Repo.Migrations.CreateFriends do
  use Ecto.Migration

  def change do
    create table(:friends) do
      add :user_a_id, :integer
      add :user_b_id, :integer
      add :accepted, :boolean, default: false, null: false

      timestamps()
    end

  end
end
