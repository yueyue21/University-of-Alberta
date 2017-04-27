mention: mention.o memwatch.o 
	gcc -std=c99 -Wall -o mention mention.o memwatch.o
mention.o: mention.c memwatch.h 
	gcc -std=c99 -Wall -c mention.c -DMEMWATCH -DMW_STDIO
memwatch.o: memwatch.c memwatch.h
	gcc -std=c99 -Wall -c memwatch.c -DMEMWATCH -DMW_STDIO
clean:
	-rm -f *.o mention core
