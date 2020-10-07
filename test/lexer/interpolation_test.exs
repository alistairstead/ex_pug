defmodule ExPug.Lexer.InterpolationTest do
  use ExPug.TemplateCase, async: true

  describe "interpolation" do
    test "string interpolation, escaped" do
      """
      - var title = "On Dogs: Man's Best Friend";
      - var author = "enlore";
      - var theGreat = "<span>escape!</span>";

      h1= title
      p Written with love by <%= author %>
      p This will be safe: <%= theGreat %>
      """ >>>
        [
          {:code, 1, 'var title = "On Dogs: Man\'s Best Friend";'},
          {:eol, 1},
          {:code, 2, 'var author = "enlore";'},
          {:eol, 2},
          {:code, 3, 'var theGreat = "<span>escape!</span>";'},
          {:eol, 3},
          {:eol, 4},
          {:name, 5, 'h1'},
          {:bufferedcode, 5},
          {:name, 5, 'title'},
          {:eol, 5},
          {:name, 6, 'p'},
          {:text, 6, 'Written with love by <%= author %>'},
          {:eol, 6},
          {:name, 7, 'p'},
          {:text, 7, 'This will be safe: <%= theGreat %>'},
          {:eol, 7}
        ]
    end
  end
end
