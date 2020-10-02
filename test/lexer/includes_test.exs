defmodule ExPug.Lexer.IncludesTest do
  use ExPug.TemplateCase, async: true

  describe "includes" do
    test "include pug files" do
      """
      //- index.pug
      doctype html
      html
        include includes/head.pug
        body
          h1 My Site
          p Welcome to my super lame site.
          include includes/foot.pug
      """ >>>
        [
          {:pugcomment, 1},
          {:text, 1, 'index.pug'},
          {:eol, 1},
          {:name, 2, 'doctype'},
          {:text, 2, 'html'},
          {:eol, 2},
          {:name, 3, 'html'},
          {:eol, 3},
          {:indent, 4, 2},
          {:name, 4, 'include'},
          {:text, 4, 'includes/head.pug'},
          {:eol, 4},
          {:indent, 5, 2},
          {:name, 5, 'body'},
          {:eol, 5},
          {:indent, 6, 4},
          {:name, 6, 'h1'},
          {:text, 6, 'My Site'},
          {:eol, 6},
          {:indent, 7, 4},
          {:name, 7, 'p'},
          {:text, 7, 'Welcome to my super lame site.'},
          {:eol, 7},
          {:indent, 8, 4},
          {:name, 8, 'include'},
          {:text, 8, 'includes/foot.pug'},
          {:eol, 8}
        ]
    end

    test "include plain text" do
      """
      //- index.pug
      doctype html
      html
        head
          style
            include style.css
        body
          h1 My Site
          p Welcome to my super lame site.
          script
            include script.js
      """ >>>
        [
          {:pugcomment, 1},
          {:text, 1, 'index.pug'},
          {:eol, 1},
          {:name, 2, 'doctype'},
          {:text, 2, 'html'},
          {:eol, 2},
          {:name, 3, 'html'},
          {:eol, 3},
          {:indent, 4, 2},
          {:name, 4, 'head'},
          {:eol, 4},
          {:indent, 5, 4},
          {:name, 5, 'style'},
          {:eol, 5},
          {:indent, 6, 6},
          {:name, 6, 'include'},
          {:text, 6, 'style.css'},
          {:eol, 6},
          {:indent, 7, 2},
          {:name, 7, 'body'},
          {:eol, 7},
          {:indent, 8, 4},
          {:name, 8, 'h1'},
          {:text, 8, 'My Site'},
          {:eol, 8},
          {:indent, 9, 4},
          {:name, 9, 'p'},
          {:text, 9, 'Welcome to my super lame site.'},
          {:eol, 9},
          {:indent, 10, 4},
          {:name, 10, 'script'},
          {:eol, 10},
          {:indent, 11, 6},
          {:name, 11, 'include'},
          {:text, 11, 'script.js'},
          {:eol, 11}
        ]
    end
  end
end
