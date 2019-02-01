grammar Calculator; 

@header {
    import java.util.HashMap;
    import java.lang.Math;
}

@members {
    HashMap<String, Integer> variables = new HashMap<String, Integer>();
}

// Top-Most Expression Tree Nodes
exprList: topExpr ( ';' topExpr)* ';'? ; 
topExpr: varDef | expr{ System.out.println("result: " + Integer.toString($expr.i)); };

// Variable Definitions
varDef: ID '=' val=expr {variables.put($ID.text, $val.i);};

expr returns [int i]: 
    el=expr op='*' er=expr { $i=$el.i*$er.i; }
    | el=expr op='/' er=expr { $i=$el.i/$er.i; }
    | el=expr op='+' er=expr { $i=$el.i+$er.i; }
    | el=expr op='-' er=expr { $i=$el.i-$er.i; }
    | INT { $i=Integer.parseInt($INT.text); }
    | ID {
            if(variables.get($ID.text) != null)
                $i = variables.get($ID.text);
            else
                System.out.println("Undeclared variable.");
        }            
    | '(' e=expr ')'
    | '!' expr { $i = $expr.i != 0 ? 1 : 0 ;}
    | el=expr op='&&' er=expr { $i = ($el.i != 0 && $er.i != 0) ? 1 : 0; }
    | el=expr op='||' er=expr {$i = ($el.i != 0 || $er.i != 0) ? 1 : 0; }
    ;

spexp returns [double i]:
    SQRT_L value=expr FUNC_R
     { 
            if ($value.i < 0)
                System.out.println("Error: expression must be positive");
            else
                $i = Math.sqrt($value.i); 
        }
    |
    ;


libfun returns [double i]:
    's(' var=libfun ')'{ $i= Math.sin($var.i); }
    | 'c(' var=libfun ')'{ $i= Math.cos($var.i); }
    | 'l(' var=libfun ')'{ $i= Math.log($var.i); }
    | 'e(' var=libfun ')'{ $i= Math.exp($var.i); }
    ;

INT: '-'?[0-9]+ ; // Recognize Integers
WS : SPACE+ -> skip ; // Skip White Space
COM : '/*' (.)*? '*/' -> skip ; // Skip Comments
SPACE: [ \t\r\n];
SQRT_L: 'sqrt'SPACE*'(';
FUNC_R: SPACE*')';
ID: [_A-Za-z]+;