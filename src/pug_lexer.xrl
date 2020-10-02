Definitions.

EOL                   = \n|\r\n|\r
WS                    = [\s\t]
INDENT                = ({WS}{WS})+

% TAG
NAME                  = [a-z][A-Za-z0-9_-]*
DOT                   = \.
HASH                  = #
OPENATTRS             = \(
CLOSEATTRS            = \)
EQ                    = =
STRING                = ="[^\"]+"|='[^\']+'
ATTRIBUTE             = ({OPENATTRS}|{WS}){NAME}{EQ}
CLASS                 = {DOT}{NAME}
ID                    = {HASH}{NAME}
CLOSETAG              = /
SYMBOLS               = [{EQ}{OPENATTRS}{CLOSEATTRS}]

% PLAIN TEXT
OPENHTML              = <[^>]+>
CLOSEHTML             = </[^>]+>
HTMLLITERAL           = {OPENHTML}|{CLOSEHTML}
WORD                  = [^\(\)\t\s\n\.#=]+
PIPE                  = \|
COLON                 = :\s
% TODO this can be simplified if the preceeding tokens return a string
TEXT                  = (\s|[A-Z0-9\`\'\"]|#\s)[^\s][^\n]+
PIPETEXT              = {PIPE}{WS}[^\n]+
BLOCK                 = {DOT}{EOL}

% COMMENT
COMMENT               = \/\/[^-]
PUGCOMMENT            = \/\/-

% FILTER
FILTER                = :{NAME}

% CODE
CODE                  = \-\s[^\n]+
CODEBLOCK             = \-\n.*[\na-z]
BUFFEREDCODE          = =\s
UNBUFFEREDCODE        = !=\s

BLANK                 = {PIPE}{EOL}

Rules.

% Tag rules
{NAME}   : {token, {name, TokenLine, TokenChars}}.
{CLASS}  : {token, {class, TokenLine, strip_first(TokenChars)}}.
{ID}  : {token, {id, TokenLine, strip_first(TokenChars)}}.
{ATTRIBUTE} : {token, {attribute, TokenLine, strip_first_and_last(TokenChars)}, "="}.
{SYMBOLS} : {token, {list_to_atom(TokenChars), TokenLine}}.
{STRING} : {token, {string, TokenLine, extract_string(TokenChars)}}.
{CLOSETAG} : {token, {closetag, TokenLine}}.

% Text rules
{TEXT}   : {token, {text, TokenLine, strip_spaces(TokenChars)}}.
{PIPETEXT}   : {token, {text, TokenLine, strip_spaces(strip_first(TokenChars))}}.
{HTMLLITERAL} : {token, {text, TokenLine, strip_spaces(TokenChars)}}.

{BLOCK}    : {token, {block, TokenLine}}.
{COLON} : {token, {colon, TokenLine}}.

{WS}     : {token, {ws, TokenLine, TokenLen}}.
{INDENT}     : {token, {indent, TokenLine, TokenLen}}.
{BLANK}  : {token, {blank, TokenLine}}.
{EOL}    : {token, {eol, TokenLine}}.

% Comment rules
{COMMENT} : {token, {comment, TokenLine}, " "}.
{PUGCOMMENT} : {token, {pugcomment, TokenLine}}.

% Filter rules
{FILTER} : {token, {filter, TokenLine, strip_first(TokenChars)}}.

% Code rules
{CODE} : {token, {code, TokenLine, strip_first_two(TokenChars)}}.
{CODEBLOCK} : {token, {codeblock, TokenLine, TokenChars}}.
{BUFFEREDCODE} : {token, {bufferedcode, TokenLine}}.
{UNBUFFEREDCODE} : {token, {unbufferedcode, TokenLine}}.

Erlang code.



strip_spaces(Chars) when is_list(Chars) ->
    string:strip(Chars, both).

strip_first_two(Chars) when is_list(Chars) ->
    lists:sublist(Chars, 3, length(Chars)).

strip_first(Chars) when is_list(Chars) ->
    lists:sublist(Chars, 2, length(Chars)).

strip_last(Chars) when is_list(Chars) ->
    lists:sublist(Chars, 1, length(Chars) -1).

strip_first_and_last(Chars) when is_list(Chars) ->
    strip_first(strip_last(Chars)).

extract_string(Chars) when is_list(Chars) ->
    list_to_binary(lists:sublist(Chars, 3, length(Chars) - 3)).
