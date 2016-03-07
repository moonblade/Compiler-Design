%{
	#include <stdio.h>
	int yylex(void);
	void yyerror(char *);	
	int sym[26];
%}

%token INCLUDE OUTPUT HEADERF 
%token VARNAME FUNCTION INTEGER 
%token BLOCK_BEGIN BLOCK_END END_OF_FILE 
%token DELIM INT FLOAT

%%

program:
		content	program 	 									
		| END_OF_FILE												/*{printf("%s\n", "Program ended");}*/
		|
		;				

content:
		include content
		| statement content
		| 
		;

statement:
		declaration statement
		| datatype FUNCTION	BLOCK_BEGIN statement BLOCK_END			/*{printf("%s\n", "Function Parsed");}*/
		| inputOutput DELIM statement
		|
		;

inputOutput:
		OUTPUT VARNAME												{printf("%d",sym[$2]);}
		;

declaration:
		datatype VARNAME DELIM											/*{printf("%s\n", "Declared Variable");}*/
		| datatype VARNAME '=' expression DELIM							{sym[$2]=$4;/*printf("var assigned : %d\n", $4);*/}
		;

expression:
		INTEGER														
		|expression '+' expression 									{$$ = $1 + $3;}
		|expression '*' expression 									{$$ = $1 * $3;}
		|VARNAME													{$$ = sym[$1];}
		;

datatype:
		INT
		|FLOAT
		;

include:
		INCLUDE '<' HEADERF '>' 										/*{printf("%s\n", "Encountered an include file");}*/
		;
%%

void yyerror(char *s) {
    //fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyparse();
    return 0;
}