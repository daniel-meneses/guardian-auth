defmodule Twitterclone.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :title, :string
      add :post_id, references(:posts, on_delete: :nothing)
      timestamps()
    end
  end
end
