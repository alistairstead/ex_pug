defmodule ExPug.Lexer.ElementTest do
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
      ":" >>>
        [
          {:":", 1}
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

    test "content" do
      " This is content" >>>
        [
          {:content, 1, ' This is content'}
        ]
    end

    test "indentation" do
      "   p This is content" >>>
        [
          {:ws, 1, 3},
          {:name, 1, 'p'},
          {:content, 1, ' This is content'}
        ]
    end
  end

  describe "tags" do
    test "bare tag" do
      "h1" >>>
        [
          {:name, 1, 'h1'}
        ]

      "p" >>>
        [
          {:name, 1, 'p'}
        ]
    end

    test "classes" do
      "h1.title.another-class" >>>
        [
          {:name, 1, 'h1'},
          {:., 1},
          {:name, 1, 'title'},
          {:., 1},
          {:name, 1, 'another-class'}
        ]
    end

    test "id" do
      "h1#identifier" >>>
        [
          {:name, 1, 'h1'},
          {:"#", 1},
          {:name, 1, 'identifier'}
        ]
    end

    test "attributes" do
      "h1(title=\"Title value\")" >>>
        [
          {:name, 1, 'h1'},
          {:"(", 1},
          {:name, 1, 'title'},
          {:=, 1},
          {:string, 1, "Title value"},
          {:")", 1}
        ]
    end

    test "combined definition" do
      "h1#identifier.class_name(title=\"Title value\")" >>>
        [
          {:name, 1, 'h1'},
          {:"#", 1},
          {:name, 1, 'identifier'},
          {:., 1},
          {:name, 1, 'class_name'},
          {:"(", 1},
          {:name, 1, 'title'},
          {:=, 1},
          {:string, 1, "Title value"},
          {:")", 1}
        ]
    end
  end

  test "tags with text content" do
    "p This is text content." >>>
      [
        {:name, 1, 'p'},
        {:content, 1, ' This is text content.'}
      ]
  end

  test "inline in a tag" do
    "p This is plain old <em>text</em> content." >>>
      [
        {:name, 1, 'p'},
        {:content, 1, ' This is plain old <em>text</em> content.'}
      ]
  end

  test "literal HTML" do
    """
    <html>

    body
      p Indenting the body tag here would make no difference.
      p HTML itself isn't whitespace-sensitive.

    </html>
    """ >>>
      [
        {:<, 1},
        {:name, 1, 'html'},
        {:>, 1},
        {:eol, 1},
        {:eol, 2},
        {:name, 3, 'body'},
        {:eol, 3},
        {:ws, 4, 2},
        {:name, 4, 'p'},
        {:content, 4, ' Indenting the body tag here would make no difference.'},
        {:eol, 4},
        {:ws, 5, 2},
        {:name, 5, 'p'},
        {:content, 5, ' HTML itself isn\'t whitespace-sensitive.'},
        {:eol, 5},
        {:eol, 6},
        {:<, 7},
        {:closetag, 7},
        {:name, 7, 'html'},
        {:>, 7},
        {:eol, 7}
      ]
  end
end
