defmodule Twitterclone.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :bio, :string
      add :image, :string
      add :alias, :string
      timestamps()
    end
  end
end
