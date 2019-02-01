grammar Calculator; 

@header {
    import java.util.HashMap;
    import java.lang.Math;
}

@members {
    HashMap<String, Integer> variables = new HashMap<String, Integer>();
}

exprList: topExpr ( ';' topExpr)* ';'? ; 

topExpr: varDef | expr{ System.out.println("result: " + Integer.toString($expr.i)); };

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

spexp returns [int i]:
    opl= 'sqrt(' /*todo var */ opr=')'{ 
            if ($var.i < 0)
                System.out.println("Error: expression must be positive");
            else
                $i= Math.sqrt($var.i); 
    };


libfun returns [int i]:
    opl= 's(' var=libfun opr=')'{ $i= Math.sin($var.i); }
    | opl= 'c(' var=libfun opr=')'{ $i= Math.cos($var.i); }
    | opl= 'l(' var=libfun opr=')'{ $i= Math.log($var.i); }
    | opl= 'e(' var=libfun opr=')'{ $i= Math.exp($var.i); }
    ;

ID: [_A-Za-z]+; // Variables and other tokens
INT: '-'?[0-9]+ ; // Recognize Integers
WS : [ \t\r\n]+ -> skip ; // Skip White Space
COM : '/*' (.)*? '*/' -> skip ; // Skip Comments
