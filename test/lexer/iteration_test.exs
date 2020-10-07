defmodule ExPug.Lexer.IterationTest do
  use ExPug.TemplateCase, async: true

  describe "iteration" do
    test "each" do
      """
      ul
        each val in [1, 2, 3, 4, 5]
          li= val
      """ >>>
        [
          {:name, 1, 'ul'},
          {:eol, 1},
          {:indent, 2, 2},
          {:name, 2, 'each'},
          {:text, 2, 'val in [1, 2, 3, 4, 5]'},
          {:eol, 2},
          {:indent, 3, 4},
          {:name, 3, 'li'},
          {:bufferedcode, 3},
          {:name, 3, 'val'},
          {:eol, 3}
        ]
    end
  end
end
