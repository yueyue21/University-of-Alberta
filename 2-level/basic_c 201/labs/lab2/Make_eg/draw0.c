/*
 * Sample program to illustrate interacting with sketchpad.pl, which is an
 * introduction to what is needed for using sketchpad.pl in Assignment 1.
 *
 * Declarations and macros and struct declarations in draw0.h
 *
 * Style not necessarily the style expected for Assignment 1.
 */

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "draw0.h"

/* executable for pipe.  could have more, perhaps all, string literals
 * as const char arrays.   quite subjective. */
const char Exec_c[]  = "java -jar Sketchpad.jar";

/*
 * draws 1 line segment, translates it:
 *  drawn based on numbers from stdin.
 *  translates it by 20,30
 *  you must translate the line and draw it
 *
 * enter 10 10 100 100 (x, y, x_diff, y_diff) on stdin (likely
 * keyboard)
 *
 * normally, break into at least 4 functions. (how many and what code
 * would go where is subjective).
 *
 * many constants (numbers, like 4) and string literals (like
 * "%lf%lf%lf%lf") could respectively be macros and const char arrays
 * in draw0.h ... very subjective.
 */
int main()
{
  struct point start;
  double x_diff, y_diff;
  char line[MAX_LINE_LEN + 1];

  printf("Enter 4 doubles separated by spaces: x y x_diff y_diff\n");

  /* reads 1 line from stdin.  should normally check return value, and
   * zero line via memset ...  will see in a another sample program.
   * */
  fgets(line, MAX_LINE_LEN + 1, stdin);

  /* parses line.  recognizes 4 doubles, and stores them.  why check
   * for a ret. val. of 4?  */
  if (sscanf(line, "%lf%lf%lf%lf", &start.x, &start.y, &x_diff, &y_diff) != 4)
  {
    fprintf(stderr, "draw0 error:  something other than exactly 4 doubles.\n");
    exit(EXIT_FAILURE);
  }

  struct point end;
  end.x = start.x + x_diff;
  end.y = start.y + y_diff;

  FILE* sketcher;

  /* opens pipe to executable */
  sketcher = popen(Exec_c, "w");
  if (sketcher == NULL)
  {
    fprintf(stderr, "draw0 error:  couldn't open a pipe to %s\n", Exec_c);
    exit(EXIT_FAILURE);
  }

  /* these variables make it more readable (some would argue) */
  long x1, y1, x2, y2;

  x1 = lround(start.x);
  y1 = lround(start.y);
  x2 = lround(end.x);
  y2 = lround(end.y);

  /* sends instructions to sketchpad.pl's stdin, which sends instructions to
   * sketchapd, which draws 1st line segment*/
  fprintf(sketcher, "drawSegment %ld %ld %ld %ld\n", x1, y1, x2, y2);

  fprintf(sketcher, "pause 1\n");

  /* ************************************************************ */

  // Add code here.

  // Translate the line by 20, 30 (20 horizontally, 30 vertically) and
  // draw it.

  // For this exercise, you can just translate the long variables.
  // _BUT_, in asn1, you will be translating the doubles.  In asn1,
  // only store the rounded values in longs right before you send them
  // to filter.

  /* ************************************************************ */

  fprintf(sketcher, "pause 2\n");
  fprintf(sketcher, "end\n");

  /* close pipe */
  if (pclose(sketcher) == -1)
  {
    fprintf(stderr, "draw_line error:  couldn't close pipe to %s.\n", Exec_c);
    exit(EXIT_FAILURE);
  }

  exit(EXIT_SUCCESS);
}
