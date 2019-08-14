// CMPUT 201 / Fall 2009 - sample code
// Written by: Davood Rafiei

#include <stdio.h>
#include <ctype.h>

int main()
{
  float operand1, operand2, result;
  int op;
  scanf("%f", &operand1);
  op = getchar();
  while (op != EOF && op != '\n') {
    // skip white spaces
    if (isspace(op)) {op = getchar(); continue;}

    scanf("%f", &operand2);
    switch (op){
      case ('+'):result = operand1 + operand2; break;
      case ('-'):result = operand1 - operand2; break;
      case ('*'):result = operand1 * operand2; break;
      case ('/'):result = operand1 / operand2; break;
      default: printf("Error - unknown operator '%c'\n", op);
    }
    operand1 = result;
    op = getchar();
  }
  printf("%f\n", result);
}

