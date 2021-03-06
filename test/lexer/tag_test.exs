defmodule ExPug.Lexer.TagTest do
  use ExPug.TemplateCase, async: true

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
          {:class, 1, 'title'},
          {:class, 1, 'another-class'}
        ]
    end

    test "id" do
      "h1#identifier" >>>
        [
          {:name, 1, 'h1'},
          {:id, 1, 'identifier'}
        ]
    end

    test "attributes" do
      "h1(title=\"Title value\")" >>>
        [
          {:name, 1, 'h1'},
          {:attribute, 1, 'title'},
          {:string, 1, "Title value"},
          {:")", 1}
        ]
    end

    test "combined definition" do
      "h1#identifier.class_name(title=\"Title value\")" >>>
        [
          {:name, 1, 'h1'},
          {:id, 1, 'identifier'},
          {:class, 1, 'class_name'},
          {:attribute, 1, 'title'},
          {:string, 1, "Title value"},
          {:")", 1}
        ]
    end

    test "nested tags" do
      """
      ul
        li Item A
        li Item B
        li Item C
      """ >>>
        [
          {:name, 1, 'ul'},
          {:eol, 1},
          {:indent, 2, 2},
          {:name, 2, 'li'},
          {:text, 2, 'Item A'},
          {:eol, 2},
          {:indent, 3, 2},
          {:name, 3, 'li'},
          {:text, 3, 'Item B'},
          {:eol, 3},
          {:indent, 4, 2},
          {:name, 4, 'li'},
          {:text, 4, 'Item C'},
          {:eol, 4}
        ]
    end

    test "block expansion" do
      "a: img" >>>
        [
          {:name, 1, 'a'},
          {:colon, 1},
          {:name, 1, 'img'}
        ]
    end

    test "self-closing tags" do
      "foo/" >>>
        [
          {:name, 1, 'foo'},
          {:closetag, 1}
        ]

      "foo(bar='baz')/" >>>
        [
          {:name, 1, 'foo'},
          {:attribute, 1, 'bar'},
          {:string, 1, "baz"},
          {:")", 1},
          {:closetag, 1}
        ]
    end
  end
end
