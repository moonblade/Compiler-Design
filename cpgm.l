	/* C Program lexical analyses */

%{
	#include "y.tab.h"
	#include <stdlib.h>
	void yyerror(char *);
%}

%%

"#include" 	return INCLUDE;

[ \t]

.			yyerror("Unknown Character");

%%

int yywrap(void) {
	return 1;
}