%option yylineno
%option noyywrap

%{
    #include "tokens.h"
%}


%%
[\t \r \n]+ {}
"print" { return TK_PRINT; }
"(" { return '('; }
")" { return ')'; }
";" { return ';'; }
"+" {return '+';}
"-" {return '-';}
"*" {return '*';}
"/" {return '/';}
">" {return '>';}
"<" {return TK_Less;}
"==" {return TK_COMPARE;}
"if" {return TK_IF;}
"let" {return TK_LET;}
"=" {return '=';}
"," {return ',';}
"begin" {return TK_BEGIN;}
"end" {return TK_END;}
"return" {return TK_RETURN;}    
[a-zA-z]+ {yylval.string_t = strdup(yytext);return TK_ID;}
[0-9]+"."[0-9]+ { yylval.float_t = atof(yytext);return TK_NUMBER;}
. {printf("Invalid character %c, line %d\n", yytext[0], yylineno); yyterminate();}
%%