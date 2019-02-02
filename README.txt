Our BC Calculator implementation can be run using the following commands:

antlr4 Calculator.g4;
javac Calculator*.java;
grun Calculator exprList -gui input.txt;

Spaces at any point of the input are ignored.
Use semicolons to separate expressions. A semicolon is optional for the final expression.
EX: 1+2; 3+2; 1-5

To declare a variable simply type the variable name, and then assign it a value. No special keywords are used.
EX: myVariable = 5;

To use a variable within an expression simply type its name.
EX: myVariable + 2;
EX: sqrt(myVariable);

Function names and variable names are case-sensitive.