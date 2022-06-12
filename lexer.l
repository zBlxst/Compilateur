%option noyywrap
%option yylineno

DIGIT [0-9]

%%

"var"       { return VAR;   }

"if"        { return IF;    }
"then"      { return THEN;  }
"else"      { return ELSE;  }

"="         { return ASSIGN; }
"=="        { return EQ;    }
"!="        { return NEQ;   }
"<="        { return LE;    }
">="        { return GE;    }
"<"         { return LT;    }
">"         { return GT;    }
":"         { return DOUBLEPOINT;    }

"||"	    { return OR;    }
"&&"	    { return AND;   }
"!"	        { return NOT;   }

"+"	        { return PLUS;  }
"*"	        { return STAR;  }
"-"	        { return MINUS; }
"/"	        { return DIV;   }

"func"      { return FUNC;  }


{DIGIT}+	{ yylval.n = atoi(yytext); return INT; }

[a-zA-Z_][a-zA-Z0-9_]*    { yylval.s = strdup(yytext); return IDENT; }

%%