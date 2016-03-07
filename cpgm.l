	/* C Program lexical analyses */

%{
	#include "y.tab.h"
	#include <stdlib.h>
	void yyerror(char *);
%}

%%

"#include" 					return INCLUDE;

"int" 						return INT;

";"							return DELIM;

"{"							return BLOCK_BEGIN;

"}"							return BLOCK_END;

[a-z_][a-z0-9_]*"()"		return FUNCTION;

[a-z_][a-z0-9_]*			return VARNAME;

[a-z]+(".h")?				{
								yylval = *yytext;
								return HEADERF;
							}

[><]						return *yytext;

[ \t]

<<EOF>>						return END_OF_FILE;

.							yyerror("Unknown Character");

%%

int yywrap(void) {
	return 1;
}