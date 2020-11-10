defmodule TwittercloneWeb.ChangesetView do
  use TwittercloneWeb, :view

  @doc """
  Traverses and translates changeset errors.

  See `Ecto.Changeset.traverse_errors/2` and
  `TwittercloneWeb.ErrorHelpers.translate_error/1` for more details.
  """
  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  def render("error.json", %{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    err = translate_errors(changeset)
    err = String.capitalize(Enum.join(List.flatten(flattenError(err)), " "))
    %{error: String.replace(err, "_", " ")}
  end

  def flattenError(err) do
    Enum.map(err, fn {a, i} ->
      case is_map(i) do
        true -> flattenError(i)
        false -> [Atom.to_string(a), i]
      end
    end)
  end

end
