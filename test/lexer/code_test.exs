defmodule ExPug.Lexer.CodeTest do
  use ExPug.TemplateCase, async: true

  describe "code" do
    test "unbuffered code" do
      """
      - for (var x = 0; x < 3; x++)
      li item
      """ >>>
        [
          {:code, 1, 'for (var x = 0; x < 3; x++)'},
          {:eol, 1},
          {:name, 2, 'li'},
          {:text, 2, 'item'},
          {:eol, 2}
        ]
    end

    @tag :skip
    test "unbuffered code block" do
      """
      -
        var list = ["Uno", "Dos", "Tres", "Cuatro", "Cinco", "Seis"]
      each item in list
        li= item
      """ >>>
        []
    end

    test "buffered code" do
      """
      p
        = 'This code is <escaped>!'
      """ >>>
        [
          {:name, 1, 'p'},
          {:eol, 1},
          {:indent, 2, 2},
          {:bufferedcode, 2},
          {:text, 2, '\'This code is <escaped>!\''},
          {:eol, 2}
        ]
    end

    test "buffered code inline" do
      """
      p= 'This code is' + ' <escaped>!'
      p(style="background: blue")= 'A message with a ' + 'blue' + ' background'
      """ >>>
        [
          {:name, 1, 'p'},
          {:bufferedcode, 1},
          {:text, 1, '\'This code is\' + \' <escaped>!\''},
          {:eol, 1},
          {:name, 2, 'p'},
          {:attribute, 2, 'style'},
          {:string, 2, "background: blue"},
          {:")", 2},
          {:bufferedcode, 2},
          {:text, 2, '\'A message with a \' + \'blue\' + \' background\''},
          {:eol, 2}
        ]
    end

    test "unescaped buffered code" do
      """
      p
        != 'This code is <strong>not</strong> escaped!'
      """ >>>
        [
          {:name, 1, 'p'},
          {:eol, 1},
          {:indent, 2, 2},
          {:unbufferedcode, 2},
          {:text, 2, '\'This code is <strong>not</strong> escaped!\''},
          {:eol, 2}
        ]
    end

    test "unescaped buffered code inline" do
      """
      p!= 'This code is' + ' <strong>not</strong> escaped!'
      """ >>>
        [
          {:name, 1, 'p'},
          {:unbufferedcode, 1},
          {:text, 1, '\'This code is\' + \' <strong>not</strong> escaped!\''},
          {:eol, 1}
        ]
    end
  end
end
