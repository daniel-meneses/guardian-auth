defmodule Twitterclone.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :message, :string
      add :views, :integer
      add :user_id, references(:users, on_delete: :nothing)
      timestamps()
    end
    alter table(:posts) do
      modify :message, :text
    end
  #  create index(:posts, [:user_id])
  end
end
