%option noyywrap
%option yylineno

DIGIT [0-9]

%%

"var"       { return VAR;   }

"if"        { return IF;    }
"then"      { return THEN;  }
"else"      { return ELSE;  }

"skip"      { return SKIP;  }

"="         { return ASSIGN; }
"=="        { return EQ;    }
"!="        { return NEQ;   }
"<="        { return LE;    }
">="        { return GE;    }
"<"         { return LT;    }
">"         { return GT;    }
":"         { return DOUBLEPOINT;    }
";"         { return SEMICOLON;      }

"||"	    { return OR;    }
"&&"	    { return AND;   }
"!"	        { return NOT;   }

"("         { return LPARENT; }
")"         { return RPARENT; }

"{"         { return LBRACK;  }
"}"         { return RBRACK;  }

"+"	        { return PLUS;  }
"*"	        { return STAR;  }
"-"	        { return MINUS; }
"/"	        { return DIV;   }

"func"      { return FUNC;  }
"for"       { return FOR;   }


{DIGIT}+	{ yylval.n = atoi(yytext); return INT; }

[a-zA-Z_][a-zA-Z0-9_]*    { yylval.s = strdup(yytext); return IDENT; }
[\"][a-zA-Z0-9_][a-zA-Z0-9_]*[\"]  { yylval.s = strdup(yytext); return STRING; }

[ \t\n\r]            {}


%%
