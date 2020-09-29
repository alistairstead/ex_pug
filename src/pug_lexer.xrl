Definitions.

NAME                  = [a-z][A-Za-z0-9_-]*
DOT                   = \.
HASH                  = #
OPENATTRS             = \(
CLOSEATTRS            = \)
OPENHTML              = <
CLOSEHTML             = >
CLOSETAG              = /
EQ                    = =
STRING                = "[^\"]+"|'[^\']+'
WORD                  = [^\(\)\t\s\n\.#=]+
EOL                   = \n|\r\n|\r
PIPE                  = \|
COLON                 = :\s
WS                    = [\s\t]
INDENT                = ({WS}{WS})+
% COMMENT               = \/\/(-)?([^\n]*)

SYMBOLS               = [{EQ}{OPENATTRS}{CLOSEATTRS}{OPENHTML}{CLOSEHTML}]
TEXT                  = (\s|[A-Z0-9])[^\s][^\n]+
PIPETEXT              = {PIPE}{WS}[^\n]+
CLASS                 = {DOT}{NAME}
ID                    = {HASH}{NAME}
BLOCK                 = {DOT}{EOL}

Rules.

{COLON} : {token, {colon, TokenLine}}.
{STRING} : {token, {string, TokenLine, extract_string(TokenChars)}}.
{NAME}   : {token, {name, TokenLine, TokenChars}}.
{CLOSETAG}   : {token, {closetag, TokenLine}}.
{WS}     : {token, {ws, TokenLine, TokenLen}}.
{INDENT}     : {token, {indent, TokenLine, TokenLen}}.
{TEXT}   : {token, {text, TokenLine, extract_text(TokenChars)}}.
{PIPETEXT}   : {token, {text, TokenLine, extract_text(strip_first(TokenChars))}}.
{CLASS}  : {token, {class, TokenLine, strip_first(TokenChars)}}.
{ID}  : {token, {id, TokenLine, strip_first(TokenChars)}}.
{BLOCK}    : {token, {block, TokenLine}}.
{EOL}    : {token, {eol, TokenLine}}.
{SYMBOLS} : {token, {list_to_atom(TokenChars), TokenLine}}.

Erlang code.

extract_string(Chars) when is_list(Chars) ->
    list_to_binary(lists:sublist(Chars, 2, length(Chars) - 2)).

extract_text(Chars) when is_list(Chars) ->
    string:strip(Chars, both).

strip_first(Chars) when is_list(Chars) ->
    lists:sublist(Chars, 2, length(Chars)).
