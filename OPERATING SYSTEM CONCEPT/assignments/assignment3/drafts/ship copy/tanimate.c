/*
 * tanimate.c: animate several strings using threads, curses, usleep()
 *
 *	bigidea one thread for each animated string
 *		one thread for keyboard control
 *		shared variables for communication
 *	compile	cc tanimate.c -lcurses -lpthread -o tanimate
 *	to do   needs locks for shared variables
 *	        nice to put screen handling in its own thread
 */

#include	<stdio.h>
#include	<curses.h>
#include	<pthread.h>
#include	<stdlib.h>
#include	<unistd.h>
#include	<string.h>

#define	MAXMSG	10		/* limit to number of threads of each kind*/
#define	TUNIT   20000		/* timeunits in microseconds */

struct	propset {
		char	*str;	/* the message */
		int	row;	/* the row     */
		int	delay;  /* delay in time units */
		char	status;	/*k:killed, e:escaped, i:initially flying*/
		int	dir;	/* +1 or -1	*/
		int	id;
	};
	
struct	ship {
		char	*str;
		int	delay;  /* delay in time units */
		int	dir;	/* +1 or -1	*/
		int	id;
		int	row;
		int 	ship_col;
	};
	
int ship_position;
pthread_mutex_t mx = PTHREAD_MUTEX_INITIALIZER;

int main(int ac, char *av[])
{
	int	       	c;		/* user input		*/
	pthread_t      	thrds[MAXMSG];	/* Saucers threads	*/
	struct propset 	props[MAXMSG];	/* properties of Saucers*/
	struct propset 	racktes[MAXMSG];  /*properties of rackets*/	
	pthread_t      	rak_thrds[MAXMSG];/*racket threads*/
	struct	ship	ship1[1];
	pthread_t	ship_tr[1];
	void	       	*animate();	/* the function		*/
	void 		*ship_animate;
	int	       	num_msg ;	/* number of saucers	*/
	int		racket;		/*number of rackets*/
	int		i;
	if ( ac == 1 ){
		printf("usage: tanimate string ..\n"); 
		exit(1);
	}
	num_msg = setup(atoi(av[1]),props);
	/* create all the threads */
	pthread_create(&ship_tr[0], NULL, ship_animate, &ship1[0]);
		
	for(i=0 ; i<num_msg; i++){
		if ( pthread_create(&thrds[i], NULL, animate, &props[i])){
			fprintf(stderr,"error creating thread");
			endwin();
			exit(0);
		}
	}
	/*
	for(i=0; i<racket;i ++){
		if ( pthread_create(&rak_thrds[i], NULL, animate, &racktes[i])){
			fprintf(stderr,"error creating thread");
			endwin();
			exit(0);
		}
	}
	*/
	/* process user input */
	while(1) {
		c = getch();
		if ( c == 'Q' ) break;
		if ( c == ' ' )
			for(i=0;i<num_msg;i++)
				props[i].dir = -props[i].dir;
		if ( c >= '0' && c <= '9' ){
			i = c - '0';
			if ( i < num_msg )
				props[i].dir = -props[i].dir;
		}
		
		if (c == ','){
			props[0].dir= -1;
		}
		if (c == '.'){
			props[0].dir=1;
		}
		
		if (c == 'f'){
			
		}
	}

	/* cancel all the threads */
	pthread_mutex_lock(&mx);
	for (i=0; i<num_msg; i++ )
		pthread_cancel(thrds[i]);
	endwin();
	return 0;
}
/*
void fire()
{
	if ( pthread_create(&thrds[i], NULL, animate, &props[i])){
			fprintf(stderr,"error creating thread");
			endwin();
			exit(0);
		}
}
*/
int setup(int nstrings, struct propset props[])
{
	int num_msg = ( nstrings > MAXMSG ? MAXMSG : nstrings );
	int i;
	
	/* assign rows and velocities to each string */
	srand(getpid());
	props[0].str="|";
	props[0].row = 2;
	props[0].dir=0;
	props[0].delay = 1+(rand()%15);	/* a speed	*/
	props[0].id=0;
	for(i=0 ; i<num_msg; i++){
		props[i].str = "<---->";/*strings[i];	/* the message	*/
		props[i].row = i;		/* the row	*/
		props[i].delay = 1+(rand()%15);	/* a speed	*/
		props[i].dir = 1;
		/*props[i].dir = ((rand()%2)?1:-1);	 +1 or -1	*/
		props[i].status = 'i';
		props[i].id = i;
	}

	/* set up curses */
	initscr();
	crmode();
	noecho();
	clear();
	ship_position=COLS/2;
	
	mvprintw(LINES-5,0,"'Q' to quit, Remaining Rackets: Number of Saucers missed: '0'..'%d' to bounce",num_msg-1);
	mvprintw(LINES-2,ship_position,"|");
	mvprintw(LINES-3,0,"%d",ship_position);
	return num_msg;
}

/* the code that runs in each thread */
void *animate(void *arg)
{
	struct propset *info = arg;		/* point to info block	*/
	int	len = strlen(info->str)+2;	/* +2 for padding	*/
	int	col = 1;/*rand()%(COLS-len-3);	/* space for padding	*/

	while( 1 )
	{
		usleep(info->delay*TUNIT);

		pthread_mutex_lock(&mx);	/* only one thread	*/
		   move( info->row, col );	/* can call curses	*/
		   addch(' ');			/* at a the same time	*/
		   addstr( info->str );		/* Since I doubt it is	*/
		   addch(' ');			/* reentrant		*/
		   move(LINES-1,COLS-1);	/* park cursor		*/
		   refresh();			/* and show it		*/
		pthread_mutex_unlock(&mx);	/* done with curses	*/

		/* move item to next column and check for bouncing	*/

		col += info->dir;
		if (col+len >= COLS){
			info->str = "             ";    /*may cause blink on the next line-----------*/
			pthread_mutex_lock(&mx);	/* only one thread	*/
		   	move( info->row, col );		/* can call curses	*/
		  	//addch(' ');			/* at a the same time	*/
			addstr(info->str);		/* Since I doubt it is	*/
			addch(' ');			/* reentrant		*/
			move(LINES-1,COLS-1);		/* park cursor		*/
			refresh();			/* and show it		*/
			pthread_mutex_unlock(&mx);	/* done with curses	*/
			
		}
		/*
		if ( col <= 0 && info->dir == -1 )
			info->dir = 1;
		else if (  col+len >= COLS && info->dir == 1 )
			info->dir = -1;
		*/
	}
}
void *ship_animate(void *arg)
{	//mvprintw(LINES-6,0,"asdf12121321321it, Rem%d",ship_col);
	struct 	ship *info = arg;		/* point to info block	*/
	int	len = strlen(info->str)+2;	/* +2 for padding	*/
	while( 1 )
	{
		usleep(info->delay*TUNIT);
		pthread_mutex_lock(&mx);
		move( LINES-1, info->ship_col );	
		addch(' ');			/* at a the same time	*/
		addstr( info->str );		/* Since I doubt it is	*/
		addch(' ');			/* reentrant		*/
		move(LINES-1,COLS-1);		/* park cursor		*/
		refresh();			/* and show it		*/
		pthread_mutex_unlock(&mx);
		info->ship_col+= info->dir;
		if (info->ship_col+len >= COLS || info->ship_col <= 1){
			info->ship_col-= info->dir;
		}
		info->dir = 0;		/*make it stable if no keybord interuption*/
	}
}
