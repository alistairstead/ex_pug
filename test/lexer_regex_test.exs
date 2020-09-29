defmodule ExPug.LexerRegexTest do
  use ExUnit.Case, async: true

  alias ExPug.Lexer
  doctest Lexer

  defmacro input >>> expected do
    quote do
      case Lexer.tokenize(unquote(input)) do
        {:ok, tokens, _} -> assert unquote(expected) == tokens
        {:error, lexer_error, _} -> assert unquote(expected) == lexer_error
      end
    end
  end

  describe "regex patterns" do
    test "name" do
      "name" >>>
        [
          {:name, 1, 'name'}
        ]
    end

    test "dot" do
      "." >>>
        [
          {:., 1}
        ]
    end

    test "class" do
      ".class_name" >>>
        [
          {:., 1},
          {:name, 1, 'class_name'}
        ]
    end

    test "hash" do
      "#" >>>
        [
          {:"#", 1}
        ]
    end

    test "string" do
      "\"string\"" >>>
        [
          {:string, 1, "string"}
        ]
    end

    test "pipe" do
      "|" >>>
        [
          {:|, 1}
        ]
    end

    test "colon" do
      ": " >>>
        [
          {:colon, 1}
        ]
    end

    test "html" do
      """
      <html>
      </html>
      """ >>>
        [
          {:<, 1},
          {:name, 1, 'html'},
          {:>, 1},
          {:eol, 1},
          {:<, 2},
          {:closetag, 2},
          {:name, 2, 'html'},
          {:>, 2},
          {:eol, 2}
        ]
    end

    test "text" do
      " This is text" >>>
        [
          {:text, 1, 'This is text'}
        ]
    end

    test "indentation" do
      "  p This is text" >>>
        [
          {:indent, 1, 2},
          {:name, 1, 'p'},
          {:text, 1, 'This is text'}
        ]
    end
  end
end
