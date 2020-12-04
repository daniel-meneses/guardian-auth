defmodule Twitterclone.Repo.Migrations.AddLinkPreviews do
  use Ecto.Migration

  def change do
    create table(:link_previews) do
      add :title, :string
      add :description, :text
      add :image, :string
      add :url, :string
      add :post_id, references(:posts, on_delete: :delete_all)
      timestamps()
    end
  end
end
