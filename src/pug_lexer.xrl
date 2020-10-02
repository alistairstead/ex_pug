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
STRING                = "[^\"]+"|'[^\']+'
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
TEXT                  = (\s|[A-Z0-9])[^\s][^\n]+
PIPETEXT              = {PIPE}{WS}[^\n]+
BLOCK                 = {DOT}{EOL}

% COMMENT
COMMENT               = \/\/[^-]
PUGCOMMENT            = \/\/-

BLANK                 = {PIPE}{EOL}

Rules.

% Tag rules
{NAME}   : {token, {name, TokenLine, TokenChars}}.
{CLASS}  : {token, {class, TokenLine, strip_first(TokenChars)}}.
{ID}  : {token, {id, TokenLine, strip_first(TokenChars)}}.
{SYMBOLS} : {token, {list_to_atom(TokenChars), TokenLine}}.
{STRING} : {token, {string, TokenLine, extract_string(TokenChars)}}.
{CLOSETAG} : {token, {closetag, TokenLine}}.

% Text rules
{TEXT}   : {token, {text, TokenLine, extract_text(TokenChars)}}.
{PIPETEXT}   : {token, {text, TokenLine, extract_text(strip_first(TokenChars))}}.
{HTMLLITERAL} : {token, {text, TokenLine, extract_text(TokenChars)}}.

{BLOCK}    : {token, {block, TokenLine}}.
{COLON} : {token, {colon, TokenLine}}.

{WS}     : {token, {ws, TokenLine, TokenLen}}.
{INDENT}     : {token, {indent, TokenLine, TokenLen}}.
{BLANK}  : {token, {blank, TokenLine}}.
{EOL}    : {token, {eol, TokenLine}}.

% Comment rules
{COMMENT} : {token, {comment, TokenLine}, " "}.
{PUGCOMMENT} : {token, {pugcomment, TokenLine}}.

Erlang code.

extract_string(Chars) when is_list(Chars) ->
    list_to_binary(lists:sublist(Chars, 2, length(Chars) - 2)).

extract_text(Chars) when is_list(Chars) ->
    string:strip(Chars, both).

strip_first(Chars) when is_list(Chars) ->
    lists:sublist(Chars, 2, length(Chars)).
