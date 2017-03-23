/*
 * Declarations and includes and macros for draw0.c.
 *
 * See draw0.c for more information.
 */
#ifndef DRAW0_H
#define DRAW0_H

#define MAX_LINE_LEN 256

/* declaration for executable.  definition in draw0.h.  see draw0.h
 * for more info. */
extern const char Exec_c[];

/* represents a point */
struct point
{
  double x;
  double y;
};

/* prototypes for non-c99 library functions */
FILE* popen(const char*, const char*);
int pclose(FILE*);

#endif
