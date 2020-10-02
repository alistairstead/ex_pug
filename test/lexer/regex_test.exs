defmodule ExPug.Lexer.RegexTest do
  use ExPug.TemplateCase, async: true

  describe "regex patterns" do
    test "name" do
      "name" >>>
        [
          {:name, 1, 'name'}
        ]
    end

    test "class" do
      ".class_name" >>>
        [
          {:class, 1, 'class_name'}
        ]
    end

    test "hash" do
      "#identifier" >>>
        [
          {:id, 1, 'identifier'}
        ]
    end

    test "string" do
      "\"string\"" >>>
        [
          {:string, 1, "string"}
        ]
    end

    test "pipe text" do
      "| text" >>>
        [
          {:text, 1, 'text'}
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