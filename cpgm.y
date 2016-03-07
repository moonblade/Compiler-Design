%{
	#include <stdio.h>
	int yylex(void);
	void yyerror(char *);	
%}

%token INCLUDE
%token HEADERF
%token VARNAME
%token FUNCTION
%token BLOCK_BEGIN
%token BLOCK_END
%token END_OF_FILE
%token DELIM
%token INT
%token FLOAT

%%

program:
		program content END_OF_FILE
		|
		;				

content:
		include content
		| statement content
		|
		;

statement:
		declaration statement
		| datatype FUNCTION	BLOCK_BEGIN statement BLOCK_END			{printf("%s\n", "Main");}
		|
		;


declaration:
		datatype VARNAME DELIM										{printf("%s\n", "Declared Variable");}
		;

datatype:
		INT
		|FLOAT
		;

include:
		INCLUDE '<' HEADERF '>' 										{printf("%s\n", "Encountered an include file");}
		;
%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}