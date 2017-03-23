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

#define	MAXMSG	201		/* limit to number of threads of each kind*/
#define	TUNIT   20000		/* timeunits in microseconds */
#define BUILT   13000		/*BULIT SPEED DITERMINATION*/

struct	propset {
		char	*str;	/* the message */
		int	row;	/* the row     */
		int	delay;  /* delay in time units */
		int	dir;	/* +1 or -1	*/
		int	id;
	};
	
pthread_mutex_t mx = PTHREAD_MUTEX_INITIALIZER;
int ship_col;
int main(int ac, char *av[])
{
	
	int	       	c;		/* user input		*/
	pthread_t      	thrds[MAXMSG];	/* Saucers threads	*/
	struct propset 	props[MAXMSG];/* properties of Saucers*/
	void 		*ship_animate();	
	void	       	*animate();	/* the function		*/
	int	       	num_msg ;	/* number of saucers	*/
	int		i;
	

	if ( ac == 1 ){
		printf("usage: tanimate string ..\n"); 
		exit(1);
	}
	num_msg = setup(props);
	/* create all the threads */
	//pthread_create(&thrds[0], NULL, ship_animate, &props[0]);
	/*ship thread*/
	
	/*scursors threads*/
		
	for(i=0 ; i<num_msg; i++){
	if (i==0){
		mvprintw(15,0,"a////////1321it, Rem");
		
		//pthread_create(&thrds[i], NULL, ship_animate, &props[i]);
		
	}
	if( 1<i<100){
		mvprintw(LINES-3,0,"7777, Rem%d----%d",num_msg,i);
		if ( pthread_create(&thrds[i], NULL, animate, &props[i])){
			fprintf(stderr,"error creating thread");
			endwin();
			exit(0);
			}
		}
		
	}
	
	
	
	
	/* process user input */
	while(1) {
		
		c = getch();
		if ( c == 'Q' ) break;
		
		if (c == ','){
			props[0].dir= -1;
		}
		if (c == '.'){
			props[0].dir=1;
		}
	}
	/* cancel all the threads */
	pthread_mutex_lock(&mx);
	for (i=0; i<num_msg; i++ )
		pthread_cancel(thrds[i]);
	endwin();
	return 0;
}

int setup(struct propset props[])
{	
	int num_msg =10;
	int i;
	srand(getpid());
	/*ship*/
	props[0].str="|";
	props[0].row = 2;
	props[0].dir=0;
	props[0].delay = 1+(rand()%15);	/* a speed	*/
	props[0].id=0;
	for(i=1 ; i<num_msg; i++){
		props[i].str = "<---->";	/* the message	*/
		props[i].row = i-1;		/* the row	*/
		props[i].delay = 1+(rand()%15);	/* a speed	*/
		props[i].dir = 1;
		props[i].id = i;
	}
	/* set up curses */
	initscr();
	crmode();
	noecho();
	clear();
	mvprintw(LINES-1,0,"'Q' to quit, Remaining Rackets: Number of Saucers missed: '0'..'%d--%d' to bounce",num_msg,ship_col);
	ship_col=COLS/2;
	//mvprintw(LINES-2,COLS/2,"|");
	//mvprintw(LINES-4,0,"%d\n",COLS/2);
	return num_msg;
}

/* the code that runs in each thread */

void *ship_animate(void *arg)
{	//mvprintw(LINES-6,0,"asdf12121321321it, Rem%d",ship_col);
	struct 	propset *info = arg;		/* point to info block	*/
	int	len = strlen(info->str)+2;	/* +2 for padding	*/
	while( 1 )
	{
		usleep(info->delay*TUNIT);
		pthread_mutex_lock(&mx);
		move( LINES-1, ship_col );	
		addch(' ');			/* at a the same time	*/
		addch( '|' );		/* Since I doubt it is	*/
		addch(' ');			/* reentrant		*/
		move(LINES-1,COLS-1);		/* park cursor		*/
		refresh();			/* and show it		*/
		pthread_mutex_unlock(&mx);
		ship_col+= info->dir;
		if (ship_col+len >= COLS || ship_col <= 1){
			ship_col-= info->dir;
		}
		info->dir = 0;		/*make it stable if no keybord interuption*/
	}
}
void *animate(void *arg)
{
	struct propset *info = arg;		/* point to info block	*/
	int	len = strlen(info->str)+2;	/* +2 for padding	*/
	int	col = 1;			/* space for padding	*/
	
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
		col += info->dir;
		if (col+len >= COLS){
			info->str = "             ";    /*may cause blink on the next line-----------*/
			pthread_mutex_lock(&mx);	/* only one thread	*/
		   	move( info->row, col );		/* can call curses	*/
			addstr(info->str);		/* Since I doubt it is	*/
			addch(' ');			/* reentrant		*/
			move(LINES-1,COLS-1);		/* park cursor		*/
			refresh();			/* and show it		*/
			pthread_mutex_unlock(&mx);	/* done with curses	*/
			
		}
	}
}



