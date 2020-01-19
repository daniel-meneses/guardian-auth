defmodule Twitterclone.Repo.Migrations.CreateCredentials do
  use Ecto.Migration

  def change do
    create table(:credentials) do
      add :email, :string
      add :password_hash, :string
      add :user_id, references(:users, on_delete: :delete_all)
      timestamps()
    end

  end
end
