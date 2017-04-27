mention: assignment1.c
	gcc -Wall -std=c99 -o mention assignment1.c
output1:
	cat sars.txt | ./mention cough > sars-out.txt
output2:
	./mention -f sars.txt cough> sars-out.txt
output3:
	cat mars-wikipedia.txt| ./mention -l planets.txt > sars-out.txt 
output4:
	./mention -f mars-wikipedia.txt -l planets.txt > sars-out.txt
output5:
	./mention -f mars-wikipedia.txt -l gasses.txt > sars-out.txt
clean:
	-rm -f *.o mention core
	-rm -f *.o sars-out.txt
edit:
	emacs assignment1.c
check:
	cat sars-out.txt

# man 3 getopt

