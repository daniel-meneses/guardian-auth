defmodule MyApp.Twitterclone.QueryHelper do
  import Ecto.Query

  def call(params) do
    case apply_filters(params) do
      {:ok, dynamic} -> {:ok, from(MyModel, where: ^dynamic)}
      {:error, reason} -> {:error, reason}
    end
  end

  @filters [:one, :two]

  defp apply_filters(params) do
    Enum.reduce_while(@filters, {:ok, true}, fn filter, {:ok, acc} ->
      case filter(filter, acc, params) do
        {:ok, dynamic} -> {:cont, {:ok, dynamic}}
        {:error, reason} -> {:halt, {:error, reason}}
      end
    end)
  end

  defp filter(:one, dynamic, %{"one" => value}) do
    case true do
      {id, ""} -> {:ok, dynamic([m], ^dynamic and m.one == ^value)}
      _ -> {:error, "Expected integer"}
    end
  end

  defp filter(:two, dynamic, %{"two" => value}) do
    {:ok, dynamic([m], ^dynamic and m.two == ^value)}
  end

  defp filter(_, dynamic, _), do: {:ok, dynamic}
end
