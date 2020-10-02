defmodule ExPug.Lexer.TextTest do
  use ExPug.TemplateCase, async: true

  describe "plain text" do
    test "tags with text text" do
      "p This is text text." >>>
        [
          {:name, 1, 'p'},
          {:text, 1, 'This is text text.'}
        ]
    end

    test "inline in a tag" do
      "p This is plain old <em>text</em> text." >>>
        [
          {:name, 1, 'p'},
          {:text, 1, 'This is plain old <em>text</em> text.'}
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
          {:indent, 4, 2},
          {:name, 4, 'p'},
          {:text, 4, 'Indenting the body tag here would make no difference.'},
          {:eol, 4},
          {:indent, 5, 2},
          {:name, 5, 'p'},
          {:text, 5, 'HTML itself isn\'t whitespace-sensitive.'},
          {:eol, 5},
          {:eol, 6},
          {:<, 7},
          {:closetag, 7},
          {:name, 7, 'html'},
          {:>, 7},
          {:eol, 7}
        ]
    end

    test "piped text" do
      """
      p
        | The pipe always goes at the beginning of its own line,
        | not counting indentation.
      """ >>>
        [
          {:name, 1, 'p'},
          {:eol, 1},
          {:indent, 2, 2},
          {:text, 2, 'The pipe always goes at the beginning of its own line,'},
          {:eol, 2},
          {:indent, 3, 2},
          {:text, 3, 'not counting indentation.'},
          {:eol, 3}
        ]
    end

    @tag :skip
    test "block in a tag" do
      """
      script.
        if (usingPug)
          console.log('you are awesome')
        else
          console.log('use pug')
      """ >>>
        [
          {:name, 1, 'script'},
          {:., 1},
          {:eol, 1},
          {:indent, 2, 2},
          {:text, 2, 'if (usingPug)'},
          {:eol, 2},
          {:indent, 3, 4},
          {:text, 3, 'console.log(\'you are awesome\')'},
          {:eol, 3},
          {:indent, 4, 2},
          {:text, 4, 'else'},
          {:eol, 4},
          {:indent, 5, 4},
          {:text, 5, 'console.log(\'use pug\')'},
          {:eol, 5}
        ]
    end

    test "dot block of plain text" do
      """
      div
        p This text belongs to the paragraph tag.
        br
        .
          This text belongs to the div tag.
      """ >>>
        [
          {:name, 1, 'div'},
          {:eol, 1},
          {:indent, 2, 2},
          {:name, 2, 'p'},
          {:text, 2, 'This text belongs to the paragraph tag.'},
          {:eol, 2},
          {:indent, 3, 2},
          {:name, 3, 'br'},
          {:eol, 3},
          {:indent, 4, 2},
          {:block, 4},
          {:indent, 5, 4},
          {:text, 5, 'This text belongs to the div tag.'},
          {:eol, 5}
        ]
    end
  end

  describe "whitespace control" do
    test "remove indentation preserve whitespace within elements" do
      """
      | You put the em
      em pha
      | sis on the wrong syl
      em la
      | ble.
      """ >>>
        [
          {:text, 1, 'You put the em'},
          {:eol, 1},
          {:name, 2, 'em'},
          {:text, 2, 'pha'},
          {:eol, 2},
          {:text, 3, 'sis on the wrong syl'},
          {:eol, 3},
          {:name, 4, 'em'},
          {:text, 4, 'la'},
          {:eol, 4},
          {:text, 5, 'ble.'},
          {:eol, 5}
        ]
    end

    test "period after a link" do
      """
      a ...sentence ending with a link
      | .
      """ >>>
        [
          {:name, 1, 'a'},
          {:text, 1, '...sentence ending with a link'},
          {:eol, 1},
          {:text, 2, '.'},
          {:eol, 2}
        ]
    end

    test "empty piped lines" do
      """
      | Don't
      |
      button#self-destruct touch
      |
      | me!
      """ >>>
        [
          {:text, 1, 'Don\'t'},
          {:eol, 1},
          {:blank, 2},
          {:name, 3, 'button'},
          {:id, 3, 'self-destruct'},
          {:text, 3, 'touch'},
          {:eol, 3},
          {:blank, 4},
          {:text, 5, 'me!'},
          {:eol, 5}
        ]
    end

    @tag :skip
    test "plain text block" do
      """
      p.
        Using regular tags can help keep your lines short,
        but interpolated tags may be easier to #[em visualize]
        whether the tags and text are whitespace-separated.
      """ >>>
        [
          {:name, 1, 'p'},
          {:block, 1},
          {:indent, 2, 2},
          {:text, 2, 'Using regular tags can help keep your lines short,'},
          {:eol, 2},
          {:indent, 3, 2},
          {:text, 3, 'but interpolated tags may be easier to #[em visualize]'},
          {:eol, 3},
          {:indent, 4, 2},
          {:text, 4, 'whether the tags and text are whitespace-separated.'},
          {:eol, 4}
        ]
    end
  end
end
