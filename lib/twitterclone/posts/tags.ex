defmodule Twitterclone.Tags do
  import Ecto.Query, warn: false

  alias Twitterclone.Repo
  alias Twitterclone.Tags.Tag

  def create_tag(title) do
    Tag.changeset(%Tag{}, %{title: title})
    |> Repo.insert()
  end

  def get_tags(%{"group_by" => group_by, "limit" => limit}) do
    Repo.all(from(t in Tag,
    limit: ^limit,
    group_by: [^String.to_atom(group_by)],
    select: %{tag: t.title, count: count(t.id)}))
  end

end
