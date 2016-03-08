%{
	#include <stdio.h>
	int yylex(void);
	void yyerror(char *);	
	int sym[26];
	extern FILE* yyin;
%}

%token INCLUDE OUTPUT INPUT HEADERF 
%token FUNCTION 
%token END_OF_FILE 
%token DELIM INT FLOAT
%token WHILE
%token INTEGER
%token VARNAME
%token IDENTIFIER

%union
{
	char *string;
	int number;	
}

%type<number> expression
%type<number> INTEGER
%type<string> IDENTIFIER

%left '+' '-'
%left '*' '/'

%%

content:
		include content
		| statement content
		| END_OF_FILE
		;

statement:
		declaration statement
		| datatype FUNCTION	'{' statement '}'			/*{printf("%s\n", "Function Parsed");}*/
		| inputOutput DELIM statement
		| assignment
		|
		;

inputOutput:
		OUTPUT IDENTIFIER												{printf("%d\n",$2);}
		|INPUT IDENTIFIER												{scanf("%d",&$2);}
		;

assignment:
		IDENTIFIER '=' expression										{*$1=$3;}
		;

declaration:
		datatype IDENTIFIER DELIM											/*{int $2;}*/{printf("%s\n", $2);}
		| datatype IDENTIFIER '=' expression DELIM							{*$2=$4;/*printf("var assigned : %d\n", $4);*/}
		;

expression:
		INTEGER														
		|expression '+' expression 									{$$ = $1 + $3;}
		|expression '-' expression 									{$$ = $1 - $3;}
		|expression '*' expression 									{$$ = $1 * $3;}
		|expression '/' expression 									{$$ = $1 / $3;}
		|'(' expression  ')'										{$$ = $2;}
		|IDENTIFIER													{$$ = *$1;}
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

int main(int argc,char *argv[]) {
	yyin = fopen(argv[1],"r");
    yyparse();
    return 0;
}