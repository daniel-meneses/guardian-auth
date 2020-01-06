defmodule Twitterclone.ErrorMessages do
  def required_params(params, required) do
    errors = Enum.reduce(required, [], fn x, acc -> if is_nil(params[x]), do: [x | acc], else: acc end )
    if errors !== [], do: {:param_error, "Missing required params " <> Enum.join(errors, " ")}
  end
end
