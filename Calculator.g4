grammar Calculator; 

@header {
    import java.util.HashMap;
    import java.util.ArrayList;
    import java.lang.Math;
    import java.util.Scanner;
}

@members {
    HashMap<String, Double> variables = new HashMap<String, Double>();
    ArrayList<Double> prints = new ArrayList<Double>();
    Scanner scan = new Scanner(System.in);
}

// Top-Most Expression Tree Nodes
exprList: topExpr ( ';' topExpr)* ';'? ; 

topExpr: varDef 
        | expr{ System.out.println(Double.toString($expr.i)); }
        | PRINT SPACE* val=expr {prints.add($val.i);} (SPACE*','SPACE* expr {prints.add($expr.i);})* 
        {   
            for(Double temp: prints){
                System.out.println(Double.toString(temp));
            }
        }
        ;

// Variable Definitions
varDef: ID '=' val=expr {variables.put($ID.text, $val.i);};

expr returns [Double i]: 
    // Arithmetic Operations
    el=expr MULT er=expr { $i=$el.i*$er.i; }
    | el=expr DIVD er=expr { $i=$el.i/$er.i; }
    | el=expr ADD er=expr { $i=$el.i+$er.i; }
    | el=expr SUBT er=expr { $i=$el.i-$er.i; }
    | NUM { $i=Double.parseDouble($NUM.text); }
    | '-' NUM { $i= -1.0 * Double.parseDouble($NUM.text); } // Negative number support.
    | ID {
            if(variables.get($ID.text) != null)
                $i = variables.get($ID.text);
            else
                System.out.println("Undeclared variable.");
        }            
    | '(' e=expr ')' {$i = $expr.i;}
    // Boolean Expressions
    | '!' expr { $i = $expr.i != 0 ? 0.0 : 1.0 ;}
    | el=expr op='&&' er=expr { $i = ($el.i != 0 && $er.i != 0) ? 1.0 : 0.0; }
    | el=expr op='||' er=expr {$i = ($el.i != 0 || $er.i != 0) ? 1.0 : 0.0; }
    // Special Expressions
    | 'sqrt'SPACE*'(' value=expr SPACE*')'
        { 
            if ($value.i < 0){
                System.out.println("Error: expression must be positive");
                System.exit(0);
            }else{
                $i = Math.sqrt($value.i);
            }
        }
    | 'read'SPACE*'('SPACE*')' 
        {
            System.out.print("Enter Input: ");
            $i = scan.nextDouble();
            System.out.print("\n");
        }
    // Library Functions
    | 's'SPACE*'(' var=expr SPACE*')' { $i= Math.sin($var.i); }
    | 'c'SPACE*'(' var=expr SPACE*')' { $i= Math.cos($var.i); }
    | 'l'SPACE*'(' var=expr SPACE*')' 
        { 
            if($var.i < 0){
                System.out.println("Error: expression must be positive");
                System.exit(0);
            }else{
                $i= Math.log($var.i);
            }
        }
    | 'e'SPACE*'(' var=expr SPACE*')' { $i= Math.exp($var.i); }
    ;

PRINT:'print';
NUM: [0-9]+('.'[0-9]*)? ; // Recognize Doubles
WS : SPACE+ -> skip ; // Skip White Space
COM : '/*' (.)*? '*/' -> skip ; // Skip Comments
SPACE: [ \t\r\n];
SUBT: '-';
ADD: '+';
DIVD: '/';
MULT: '*';
ID: [_A-Za-z]+;