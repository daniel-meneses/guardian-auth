defmodule TwittercloneWeb.TypeConverter do

  def maplist_to_map2(maplist) do
    unless maplist == [], do:
    Enum.reduce(maplist, fn x, y ->
                  Map.merge(x, y, fn _k, v1, v2 -> v2 ++ v1 end)
               end)
  end

  def maplist_to_map(maplist) do
    if maplist !== [] do
      Enum.reduce(maplist, fn x, y ->
                    Map.merge(x, y, fn _k, v1, v2 -> v2 ++ v1 end)
                 end)
               else
                 %{}
          end
  end


end
