	/* C Program lexical analyses */

%{
	#include "y.tab.h"
	#include <stdlib.h>
	void yyerror(char *);
%}

%%

"#include" 					return INCLUDE;

"int" 						return INT;

"while"						return WHILE;

"cout<<" 					return OUTPUT;

"cin>>" 					return INPUT;

[0-9]+						yylval.number = atoi(yytext);return INTEGER;

";"							return DELIM;

[a-z_][a-z0-9_]*"()"		return FUNCTION;

[a-z_]						yylval.number= *yytext-'a';return VARNAME;


[a-z]+(".h")?				return HEADERF;

[><=+*{}]					return *yytext;

[ \t\n]

<<EOF>>						return END_OF_FILE;

.							yyerror("Unknown Character");

%%

int yywrap(void) {
	return 1;
}