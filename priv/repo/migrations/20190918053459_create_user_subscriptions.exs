defmodule Twitterclone.Repo.Migrations.CreateUserSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions, primary_key: false) do
      add :user_id, references(:users, on_delete: :nothing)
      add :subject_id, references(:users, on_delete: :nothing)
      add :accepted, :boolean
      timestamps()
    end
    create unique_index(:subscriptions, [:user_id, :subject_id])

  end
end
