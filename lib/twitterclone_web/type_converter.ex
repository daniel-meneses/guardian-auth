defmodule TwittercloneWeb.TypeConverter do

  def maplist_to_map(maplist) do
    unless maplist == [], do:
    Enum.reduce(maplist, fn x, y ->
                  Map.merge(x, y, fn _k, v1, v2 -> v2 ++ v1 end)
               end)
  end


end
