%{
	#include <stdio.h>
	int yylex(void);
	void yyerror(char *);	
%}

%token INCLUDE

%%

program:
		program include '\n'	{ printf("%s\n", "include file"); }
		|
		;				

include:
		INCLUDE 				{printf("%s\n", " print something");}
		|
		;
%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}