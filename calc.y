%code requires{
    #include "ast.h"
}

%{
    #include <cstdio>
    #include <fstream>
    #include <iostream>
    using namespace std;
    int yylex();
    extern int yylineno;
    void yyerror(const char * s){
        fprintf(stderr, "Line: %d, error: %s\n", yylineno, s);
    }

    #define YYERROR_VERBOSE 1
%}

%union{
   Expr * expr_t;
   Statement * statement_t;
   char * string_t;
   float float_t;
}

%token TK_PRINT
%token TK_LET TK_IF 
%token TK_BEGIN TK_END TK_RETURN
%token TK_ID TK_NUMBER
%token TK_Less TK_COMPARE


//%type<expr_t> eq;
//%type<statement_t> statement;
//%type <float_t> expr term factor

%%

program:decls statements
;

decls: decls decl
    |
    ;

decl: TK_LET TK_ID '=' eq ';';

statements: statements statement
          | statement 
          ;

statement: TK_PRINT '(' eq ')' ';' //{ printf("%f\n",$3);}
    | if_stmt
    | method_stmt
    | eq
    | return_stmt
    ;

if_stmt: TK_IF '('eq')' TK_BEGIN statements TK_END;

method_stmt: TK_LET TK_ID '(' params ')' '=' TK_BEGIN statements TK_END;

params: params ',' TK_ID;
    |term

return_stmt: TK_RETURN TK_ID ';'
    |TK_RETURN eq ';'
    |TK_RETURN TK_ID '(' params ')' ';'
    ;


eq: eq TK_COMPARE rel
    |rel
    ;
rel: rel '>' expr
    |rel TK_Less expr
    |expr
;
expr: expr '+' factor //{ $$ = $1 + $3;}
    | expr '-' factor //{ $$ = $1 - $3;}
    | factor //{$$ = $1;}
    ;



factor: factor '*' term //{$$ = $1 * $3;}
    | factor '/' term //{ $$ = $1 / $3;}
    | term //{$$ = $1;}
    ;

term: TK_NUMBER //{$$ = $1;}
    |TK_ID
    |TK_ID '('params ')'
    ;



   

%%
