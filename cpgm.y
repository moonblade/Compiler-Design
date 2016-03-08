%{
	#include <stdio.h>
	#include <string.h>
	//#define YYDEBUG 1
	int yylex(void);
	void yyerror(char *);	
	int sym[26];
	int temp;
	extern FILE* yyin;
	int count=0;
	struct variable
	{
		char *name;
		int value;
	}variables[10];

	int save(char*,int);
	int get(char*);

%}

%token INCLUDE OUTPUT INPUT HEADERF 
%token FUNCTION INOP OUTOP
%token DELIM INT FLOAT
%token WHILE _IF _ELSE
%token INTEGER
%token VARNAME
%token IDENTIFIER STRING

%union
{
	char *string;
	int number;	
}

%type<number> expression
%type<number> INTEGER
%type<string> IDENTIFIER
%type<string> STRING

%left '+' '-'
%left '*' '/'

%%

program:
		include program
		| statement program
		| 
		;

statement:
		declaration statement
		| datatype FUNCTION	'{' statement '}' statement		
		| inputOutput statement
		| assignment statement
		| _IF '(' expression ')' '{' statement '}' elsepart statement
		|
		;

elsepart:
		_ELSE '{' statement '}'
		|
		;
inputOutput:
		OUTPUT OUTOP IDENTIFIER DELIM								{printf("%d\n",get($3));}
		|INPUT INOP IDENTIFIER DELIM								{scanf("%d",&temp);save($3,temp);}
		|OUTPUT OUTOP STRING DELIM									{printf("%s",$3);}
		|OUTPUT OUTOP expression DELIM								{printf("%d",$3);}
		;

assignment:
		IDENTIFIER '=' expression DELIM								{save($1,$3);}
		;

declaration:
		datatype IDENTIFIER DELIM									{save($2,0);}/*{printf("%s\n", $2);}*/
		| datatype IDENTIFIER '=' expression DELIM					{save($2,$4);}
		;

expression:
		INTEGER														
		|expression '>' expression 									{if($1>$3){$$ = 1;}else{$$ = 0;}}
		|expression '<' expression 									{if($1<$3){$$ = 1;}else{$$ = 0;}}
		|expression '<''=' expression 								{if($1<=$4){$$ = 1;}else{$$ = 0;}}
		|expression '>''=' expression 								{if($1>=$4){$$ = 1;}else{$$ = 0;}}
		|expression '=''=' expression 								{if($1==$4){$$ = 1;}else{$$ = 0;}}
		|expression '+' expression 									{$$ = $1 + $3;}
		|expression '-' expression 									{$$ = $1 - $3;}
		|expression '*' expression 									{$$ = $1 * $3;}
		|expression '/' expression 									{$$ = $1 / $3;}
		|'(' expression  ')'										{$$ = $2;}
		|IDENTIFIER													{$$ = get($1);}
		;

datatype:
		INT
		;

include:
		INCLUDE '<' HEADERF '>' 									/*{printf("%s\n", "Encountered an include file");}*/
		;
%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int save(char *name, int value)
{
	int i;
	for(i=0;i<count;++i)
		if(!strcmp(variables[i].name,name))
		{
			variables[i].value=value;
			return 1;
		}	
	variables[count].name=name;
	variables[count].value=value;
	count++;
	return 1;
}

int get(char *name)
{
	int i;
	for(i=0;i<count;++i)
	if(!strcmp(variables[i].name,name))
	{
		return variables[i].value;
	}
	return 0;	
}

int main(int argc,char *argv[]) {
	#if YYDEBUG
		yydebug=1;
	#endif
	yyin = fopen(argv[1],"r");
    yyparse();
    return 0;
}