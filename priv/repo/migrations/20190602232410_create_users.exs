defmodule Twitterclone.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :bio, :string
      add :alias, :string
      add :device_id, :string
      add :avatar, :string
      add :private, :boolean, default: false
      timestamps()
    end
    create unique_index(:users, [:alias])
  end
end
