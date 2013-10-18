/*
*	Code-Ichiwa Scanner
*	By Aldrich Gutierrez, Joshua Cruz, Joren Sorilla
*	
*/

import java_cup.runtime.*;
import sym;

%%

%class TokenLexer
%cup
%implements sym
%line
%column
%debug

%{
  private Symbol symbol(int sym) 
  {
    return new Symbol(sym, yyline+1, yycolumn+1);
  }
  
  private Symbol symbol(int sym, Object val) 
  {
    return new Symbol(sym, yyline+1, yycolumn+1, val);
  }
 
  private void error(String message) 
  {
    System.out.println("Error at line "+(yyline+1)+", column "+(yycolumn+1)+" : "+message);
  }


%}

/*For Letters*/
Letters= [A-Za-z]


/*For Integer Literals*/
Integers= 0 | [1-9][0-9]*

/*New Line & Whitespace*/
NewLine=\r|\n|\r\n 
WhiteSpace = {NewLine} | [ \t\f]

/*Float Literals*/
Float= ({FloatType1 }|{FloatType2 }|{FloatType3 })
FloatType1    = [0-9]+ \. [0-9]* 
FloatType2    = \. [0-9]+ 
FloatType3    = [0-9]+ 

/*Character Literal*/
Character = [A-Za-z] | [0-9]

/*Identifier Literal*/
Identifier = {Letters} ({Letters} | {Integers}|_)*

/*String Literal*/
WHITE_SPACE_CHAR=[\n\r\ \t\b\012]
STRING_TEXT=(\\\" | [^\n\r\"] | \\{WHITE_SPACE_CHAR}+\\)*

/*Comment construct*/
Comment = ([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*

%%
<YYINITIAL>{

/*-----------------SEPARATORS------------------*/
  "("                            { return symbol(LPAREN); }
  ")"                            { return symbol(sym.RPAREN); }
  "{"                            { return symbol(sym.LBRACE); }
  "}"                            { return symbol(sym.RBRACE); }
  "["                            { return symbol(sym.LBRACK); }
  "]"                            { return symbol(sym.RBRACK); }
  ";"                            { return symbol(sym.SEMI); }
  ","                            { return symbol(sym.COMMA); }
  "."                            { return symbol(sym.DOT); }

/*-----------------OPERATORS------------------*/
  "+"                { System.out.println(" + "); return symbol(sym.PLUS); }
  "-"                { System.out.println(" - "); return symbol(sym.MINUS); }
  "*"                { System.out.println(" * "); return symbol(sym.TIMES); }
  "/"                { System.out.println(" / "); return symbol(sym.DIVIDE); }
  "="                { System.out.println(" = "); return symbol(sym.EQUALS); }
  
 /* identifiers */
  {Identifier} 		{ System.out.print(yytext());
                      return symbol(sym.IDENTIFIER, new Integer(1));}
	
 /* Integer */
  {Integers}        { System.out.print(yytext());
                      return symbol(sym.INTEGER, new Integer(yytext()));}
												
 /* Float */
  {Float}          	{ System.out.print(yytext());
                      return symbol(sym.FLOAT, new Float(yytext()));}
												
 /* whitespace */
 {WhiteSpace} 		{ /* SKIP THE SPACES */ }	



}
 /*Error Catch*/	
 .|\n               { error("Illegal character <"+ yytext()+">"); }