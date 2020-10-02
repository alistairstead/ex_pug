defmodule ExPug.TemplateCase do
  @moduledoc """
  This module defines the test case to be used by
  template tests.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      defmacro input >>> expected do
        quote do
          case ExPug.Lexer.tokenize(unquote(input)) do
            {:ok, tokens, _} -> assert unquote(expected) == tokens
            {:error, lexer_error, _} -> assert unquote(expected) == lexer_error
          end
        end
      end
    end
  end
end
