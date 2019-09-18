defmodule Twitterclone.Repo.Migrations.CreateUserSubscriptions do
  use Ecto.Migration

  def change do
    create table(:user_subscriptions) do
      add :user_id, references(:users, on_delete: :nothing)
      add :subject_id, references(:users, on_delete: :nothing)
      add :accepted, :boolean
      timestamps()
    end

  end
end
