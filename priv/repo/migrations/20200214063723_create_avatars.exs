defmodule Twitterclone.Repo.Migrations.CreateAvatars do
  use Ecto.Migration

  def change do
    create table(:avatars) do
      add :image, :string
      add :user_id, references(:users, on_delete: :delete_all)
      timestamps()
    end
  end
end
