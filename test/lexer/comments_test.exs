defmodule ExPug.Lexer.CommentsTest do
  use ExPug.TemplateCase, async: true

  describe "comments" do
    test "buffered comments" do
      """
      // just some paragraphs
      p foo
      p bar
      """ >>>
        [
          {:comment, 1},
          {:text, 1, 'just some paragraphs'},
          {:eol, 1},
          {:name, 2, 'p'},
          {:text, 2, 'foo'},
          {:eol, 2},
          {:name, 3, 'p'},
          {:text, 3, 'bar'},
          {:eol, 3}
        ]
    end

    test "pug comment" do
      """
      //- will not output within markup
      p foo
      p bar
      """ >>>
        [
          {:pugcomment, 1},
          {:text, 1, 'will not output within markup'},
          {:eol, 1},
          {:name, 2, 'p'},
          {:text, 2, 'foo'},
          {:eol, 2},
          {:name, 3, 'p'},
          {:text, 3, 'bar'},
          {:eol, 3}
        ]
    end

    test "block comments" do
      """
      body
      //-
      Comments for your template writers.
      Use as much text as you want.
      //
      Comments for your HTML readers.
      Use as much text as you want.
      """ >>>
        [
          {:name, 1, 'body'},
          {:eol, 1},
          {:pugcomment, 2},
          {:eol, 2},
          {:text, 3, 'Comments for your template writers.'},
          {:eol, 3},
          {:text, 4, 'Use as much text as you want.'},
          {:eol, 4},
          {:comment, 5},
          {:text, 6, 'Comments for your HTML readers.'},
          {:eol, 6},
          {:text, 7, 'Use as much text as you want.'},
          {:eol, 7}
        ]
    end

    test "conditional comments" do
      """
      doctype html

      <!--[if IE 8]>
      <html lang="en" class="lt-ie9">
      <![endif]-->
      <!--[if gt IE 8]><!-->
      <html lang="en">
      <!--<![endif]-->

      body
      p Supporting old web browsers is a pain.

      </html>
      """ >>>
        [
          {:name, 1, 'doctype'},
          {:text, 1, 'html'},
          {:eol, 1},
          {:eol, 2},
          {:text, 3, '<!--[if IE 8]>'},
          {:eol, 3},
          {:text, 4, '<html lang="en" class="lt-ie9">'},
          {:eol, 4},
          {:text, 5, '<![endif]-->'},
          {:eol, 5},
          {:text, 6, '<!--[if gt IE 8]>'},
          {:text, 6, '<!-->'},
          {:eol, 6},
          {:text, 7, '<html lang="en">'},
          {:eol, 7},
          {:text, 8, '<!--<![endif]-->'},
          {:eol, 8},
          {:eol, 9},
          {:name, 10, 'body'},
          {:eol, 10},
          {:name, 11, 'p'},
          {:text, 11, 'Supporting old web browsers is a pain.'},
          {:eol, 11},
          {:eol, 12},
          {:text, 13, '</html>'},
          {:eol, 13}
        ]
    end
  end
end
