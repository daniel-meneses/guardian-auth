defmodule Twitterclone.Repo.Migrations.CreateUserSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions) do
      add :user_id, references(:users, on_delete: :nothing)
      add :subject_id, references(:users, on_delete: :nothing)
      add :accepted, :boolean
      add :rejected, :boolean
      timestamps()
    end
    create unique_index(:subscriptions, [:user_id, :subject_id], name: :unique_subscription_index)

  end
end
