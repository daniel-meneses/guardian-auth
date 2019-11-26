defmodule Twitterclone.Repo.Migrations.CreateLikes do
  use Ecto.Migration

  def change do
    create table(:likes) do
      add :user_id, references(:users, on_delete: :nothing)
      add :post_id, references(:posts, on_delete: :nothing)
      timestamps()
    end
  #  create unique_index(:likes, [:user_id, :post_id], name: :unique_like_index)

  end
end
