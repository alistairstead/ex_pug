Definitions.

NAME                  = [A-Za-z][A-Za-z0-9_-]*
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
WS                    = [\s\t]+
BLANK                 = \n[\s\t]+\n
% COMMENT               = \/\/(-)?([^\n]*)

SYMBOLS               = [{DOT}{HASH}{PIPE}{EQ}{OPENATTRS}{CLOSEATTRS}{OPENHTML}{CLOSEHTML}]
CONTENT               = \s[^\s][^\n]+

Rules.

{SYMBOLS} : {token, {list_to_atom(TokenChars), TokenLine}}.
{COLON} : {token, {colon, TokenLine}}.
{STRING} : {token, {string, TokenLine, extract_string(TokenChars)}}.
{NAME}   : {token, {name, TokenLine, TokenChars}}.
{CLOSETAG}   : {token, {closetag, TokenLine}}.
{WS}     : {token, {ws, TokenLine, TokenLen}}.
{CONTENT} : {token, {content, TokenLine, TokenChars}}.
{EOL}    : {token, {eol, TokenLine}}.
{BLANK}    : {token, {blank, TokenLine}}.

Erlang code.

extract_string(Chars) when is_list(Chars) ->
    list_to_binary(lists:sublist(Chars, 2, length(Chars) - 2)).
