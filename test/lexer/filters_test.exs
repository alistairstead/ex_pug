defmodule ExPug.Lexer.FiltersTest do
  use ExPug.TemplateCase, async: true

  @tag :skip
  describe "filters" do
    test "filter blocks" do
      """
      :markdown-it(linkify langPrefix='highlight-')
        # Markdown

        Markdown document with http://links.com and

        ```js
        var codeBlocks;
        ```
      script
        :coffee-script
          console.log 'This is coffee script'
      """ >>>
        []
    end
  end
end
