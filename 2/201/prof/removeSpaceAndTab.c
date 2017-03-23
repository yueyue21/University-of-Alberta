// CMPUT 201 / Fall 2009 - sample code
// Written by: Davood Rafiei

#include <stdio.h>

int main() {
  char ch;
  int isSpaceOrTab = 0;
  while ((ch=getchar()) != EOF) {
    if (ch != ' ' && ch != '\t') {
      putchar(ch);
      isSpaceOrTab = 0;
    }
    else if (!isSpaceOrTab) {
      putchar(' ');
      isSpaceOrTab = 1;
    }
  }
  return 0;
}
