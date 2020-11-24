defmodule Twitterclone.Tags do
  import Ecto.Query, warn: false
  import Ecto.Type

  alias Twitterclone.{Repo, Guardian.Plug}
  alias Twitterclone.Subscriptions.Subscription
  alias Twitterclone.Tags.Tag
  alias Twitterclone.Tags

  def get_tag(title) do
    Repo.get_by(Tag, title: title)
  end

  def create_tag(title) do
    Tag.changeset(%Tag{}, %{title: title})
    |> Repo.insert()
  end

  def associate_tag(title) do
    tag =
      create_tag(title)
      |> Repo.insert_or_update()
  end

  def use_existing_or_create_tag(title) do
    case Tags.get_tag(title) do
      nil -> create_tag(title)
      tag -> {:ok, tag}
    end
  end

end
