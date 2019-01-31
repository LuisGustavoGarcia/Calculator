grammar Calculator; 

@header {
    import java.util.HashMap;
}

@members {
    HashMap<String, Integer> variables = new HashMap<String, Integer>();
}

exprList: topExpr ( ';' topExpr)* ';'? ; 

topExpr: varDef | expr{ System.out.println("result: " + Integer.toString($expr.i)); };

varDef: ID '=' val=expr {variables.put($ID.toString(), $val.i);};

expr returns [int i]: 
    el=expr op='*' er=expr { $i=$el.i*$er.i; }
    | el=expr op='/' er=expr { $i=$el.i/$er.i; }
    | el=expr op='+' er=expr { $i=$el.i+$er.i; }
    | el=expr op='-' er=expr { $i=$el.i-$er.i; }
    | INT { $i=Integer.parseInt($INT.text); }
    | ID {
            if(variables.get($ID.toString()) != null)
                $i= variables.get($ID.toString());
            else
                System.out.println("Undeclared variable.");
        }            
    | '(' e=expr ')'
    ;

ID: [_A-Za-z]+; // Variables and other tokens
INT: [0-9]+ ; // Recognize Integers
WS : [ \t\r\n]+ -> skip ; // Skip White Space
COM : '/*' (.)*? '*/' -> skip ; // Skip Comments