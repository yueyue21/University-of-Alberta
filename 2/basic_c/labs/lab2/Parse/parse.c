#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>
#include <ctype.h>
#include "parse.h"

char program_name[PROG_LEN + 1];
const char exec_name[] = "java -jar Sketchpad.jar -d";

int main(int argc, char* argv[])
{
  FILE* input;
  FILE* executable;

  memset(program_name, 0, PROG_LEN + 1);
  strncpy(program_name, argv[0], PROG_LEN);

  if (argc != 2)
    fprintf(stderr, "Usage: %s input-file\n", program_name);

  input = fopen(argv[1], "r");
  if (input == NULL)
    fprintf(stderr, "Could not open input file %s\n", argv[1]);

  executable = popen(exec_name, "w");
  if (executable == NULL)
    fprintf(stderr, "Could not open pipe %s\n", exec_name);

  convert(input, executable);

  pclose(executable);
  fclose(input);

  return EXIT_SUCCESS;
}

// Read from input, convert and send the rows to executable 
void convert(FILE* input, FILE* executable)
{
  char command[LINE_LEN + 1];
  char line[LINE_LEN + 1];
  double time_read;
  long time_sent;

  memset(line, 0, LINE_LEN + 1);
  memset(command, 0, LINE_LEN + 1);
  while (fgets(line, LINE_LEN + 1, input) != NULL)
  {
	lowerstr(line);
    /*** Add or change the code to make the input commands case-insensitive ***/
    if (strncmp(line, "clearscreen", 11) == 0)
      fprintf(executable, "clearScreen\n");
    else if (strncmp(line, "end", 3) == 0)
      fprintf(executable, "end\n");
    else if ( sscanf(line, "%s%lf", command, &time_read) == 2 &&
              strncmp(command, "pause", 5) == 0
            )
    {
      time_sent = lround(time_read);
      fprintf(executable, "pause %ld\n", time_sent);
    }
else if (sscanf(line,"%s%lf%lf%lf%lf", command, &d1,%d2,%d3,%d4,) == 5 && strncmp(command,"drawsegment",11)==0){
	fprintf("drawSegment %ld %ld %ld %ld",lround(d1),lround(d2),lround(d3),lround(d4))};

    /*** Add code to handle DRAWSegment/drawSegment here. ***/

    memset(line, 0, LINE_LEN + 1);
    memset(command, 0, LINE_LEN + 1);
  }
}

/* Conver the first n characters of str all to lowercase */ 
void lowerstr(char *str, int n)
{
  for (int i=0; str[i] && i<n; i++) 
    if (isalpha(str[i]))
      str[i] = tolower(str[i]);
}