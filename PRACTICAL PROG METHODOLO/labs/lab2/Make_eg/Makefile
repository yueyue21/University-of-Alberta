# a sample Makefile (style not correct)

# draw0.o is a dependency.  before seeing if it should invoke this
# rule's command ...
draw0: draw0.o
	gcc -Wall -std=c99 draw0.o -o draw0 -lm

# ... it invokes the rule where draw0.o is a target.
draw0.o: draw0.c draw0.h
	gcc -Wall -std=c99 -c draw0.c

clean:
		-rm -f *.o draw0 core
