// CMPUT 201 / Fall 2009 - sample code
// Written by: Davood Rafiei

#include <stdio.h>

int main()
{
  float operand1, operand2, result;
  int op;
  scanf("%f", &operand1); 
  op = getchar();
  /* scanf(" %c", &op); */
  while (op != EOF && op != '\n') {
    scanf("%f", &operand2);
    if (op=='+')
      result = operand1 + operand2;
    else if (op=='-')
      result = operand1 - operand2;
    else if (op=='*')
      result = operand1 * operand2;
    else if (op=='/')
      result = operand1 / operand2;
    else
      printf("Error - unknown operator '%c'\n", op);
    operand1 = result;
    op = getchar();  
    /* scanf(" %c", &op); */
  }
  printf("%f\n", result);
  return 0;
}

