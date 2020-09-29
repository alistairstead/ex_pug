defmodule ExPug.Lexer do
  @moduledoc false

  @doc """
  Tokenizes a template.
  """
  def tokenize(template) when is_bitstring(template),
    do: template |> String.to_charlist() |> tokenize()

  def tokenize(template) when is_list(template) do
    :pug_lexer.string(template)
  end
end
