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

#define	MAXMSG	100		/* limit to number of strings	*/
#define	TUNIT   20000		/* timeunits in microseconds */
#define SPEED	2000
#define BULIT	2000

struct	propset {
		char	*str;	/* the message */
		char	*blank;
		int	row;	/* the row     */
		int	delay;  /* delay in time units */
		int	dir;	/* +1 or -1	*/
		int	ship_col;
	};
pthread_mutex_t mx = PTHREAD_MUTEX_INITIALIZER;

int main(int ac, char *av[])
{
	int	       	c;		/* user input		*/
	pthread_t      	thrds[MAXMSG];	/* the threads		*/
	struct propset 	props[MAXMSG];	/* properties of string	*/
	struct propset 	rackets[MAXMSG];
	pthread_t      	fire_thrds[MAXMSG];
	void	       	*animate();	/* the function		*/
	int	       	num_msg ;	/* number of strings	*/
	int	    	i;
	void 		*ship_animate();
	void 		*racket_animate();
	int		total_fire=9; /*max number of rackets allowed in screen simutanisly*/
	int		fire_counter = 0;	/*racket  list counter*/
	int		game_total_fire=20;  /*rackets number given in game*/
	int 		game_fire=0;	/*rackets fired in game*/
	/*
	if ( ac == 1 ){
		printf("usage: tanimate string ..\n"); 
		exit(1);
	}
	*/
	
	num_msg = setup(20,total_fire,props,rackets);
	
	/* create all the threads */
	for(i=1 ; i<num_msg; i++)
		if ( pthread_create(&thrds[i], NULL, animate, &props[i])){
			fprintf(stderr,"error creating thread");
			endwin();
			exit(0);
		}
	pthread_create(&thrds[0], NULL, ship_animate, &props[0]);
	for(i=1 ; i<=total_fire; i++)
		if ( pthread_create(&fire_thrds[i], NULL, racket_animate, &rackets[i])){
			fprintf(stderr,"error creating thread");
			endwin();
			exit(0);
		}
	/* process user input */
	while(1) {
		c = getch();
		if ( c == 'Q' ) break;
		if (c == '['){
			props[0].dir= -1;
			for (i=0; i<=total_fire; i++ ){
				rackets[i].ship_col=props[0].ship_col;
			}
			}
		if (c == ']'){
			props[0].dir=1;
			for (i=0; i<=total_fire; i++ ){
				rackets[i].ship_col=props[0].ship_col;
			}
		}
		if (c == ' ' ){
			if(game_fire <=game_total_fire){
				/*give all rockets' information*/
				for(i=0 ; i<=total_fire; i++){
				rackets[i].ship_col=props[0].ship_col;
				rackets[i].str="^";
				rackets[i].dir=1;
				rackets[i].blank = " ";
				}
				mvprintw(LINES-1,0,"'Q' to quit,'['or']'for mov"
				"ing site,Remaining Rackets: %d  ",game_total_fire-game_fire);
				game_fire ++;
				
			}	
			else{
				mvprintw(LINES/2,COLS/2-15,"GAME OVER(running out of rockets)");
				sleep(2);
				break;
			}
		}
	}

	/* cancel all the threads */
	pthread_mutex_lock(&mx);
	for (i=0; i<num_msg; i++ )
		pthread_cancel(thrds[i]);
	for (i=0; i<total_fire; i++ )
		pthread_cancel(fire_thrds[i]);
	endwin();
	return 0;
}

int setup(int nstrings,int total_fire, struct propset props[],struct propset rackets[])
{
	int num_msg = ( nstrings > MAXMSG ? MAXMSG : nstrings );
	int i;
	/* set up curses */
	initscr();
	crmode();
	noecho();
	clear();
	/* assign rows and velocities to each string */
	srand(getpid());
	for(i=0 ; i<num_msg; i++){
	if (i ==0){
		props[i].str = "|";		/* the message	*/
		props[i].row = 15;		/* the row	*/
		props[i].delay = 3;	/* a speed	*/
		props[i].dir = 1;
		props[i].ship_col=COLS/2;
		props[i].blank = " ";
		}
	else{
		props[i].str = "<--->";	/* the message	*/
		props[i].row = 1;//(rand()%7);	/* the row	*/
		props[i].delay = 1+(rand()%15);	/* a speed	*/
		props[i].dir = 1;		/* +1 or -1	*/
		props[i].ship_col=1;		/*from left side*/
		props[i].blank = " ";
		}
	}
	for(i=0 ; i<=total_fire; i++){
		rackets[i].str = "";		/* the message	*/
		rackets[i].row = LINES-1;		/* the row starting at 1*/
		rackets[i].delay = 15;//+(rand()%7);	/* a speed	*/
		rackets[i].dir = 0;		/*rockets speed is faster*/
		rackets[i].ship_col=COLS/2;
		rackets[i].blank = "";
	}
	
	//mvprintw(LINES-1,0,"'Q' to quit, '0'..'%d' to bounce",num_msg-1);
	mvprintw(LINES-1,0,"'Q' to quit,'['or']'for moving site,Remaining Rackets: 20  Number of Saucers missed: 0");
	return num_msg;
}

/* the code that runs in each thread */
void *animate(void *arg)
{
	struct propset *info = arg;		/* point to info block	*/
	int	len = strlen(info->str)+2;	/* +2 for padding	*/
	int	col = info->ship_col;			/* space for padding	*/
	int	row = info->row;
	int	delay = info->delay;
	int	time_terminated=info->delay;	/*increasing the difficuilty of game*/
	int	row_increment=info->row;	/*increasing the difficuilty of game*/
	while( 1 )
	{
		usleep(delay*TUNIT);

		pthread_mutex_lock(&mx);	/* only one thread	*/
		   move( row, col );	/* can call curses	*/
		   addstr(info->blank);			/* at a the same time	*/
		   addstr( info->str );		/* Since I doubt it is	*/
		   addstr(info->blank);			/* reentrant		*/
		   move(LINES-1,COLS-1);	/* park cursor		*/
		   refresh();			/* and show it		*/
		   pthread_mutex_unlock(&mx);	/* done with curses	*/
	           col += info->dir;
		if (col+len >= COLS){
			time_terminated-=3;		/*increase difficulty*/
			row_increment+=2;
			pthread_mutex_lock(&mx);	/* only one thread	*/
		   	move( row, col );		
			addstr("       ");		
			//refresh();			/* and show it		*/
			col = 1;			/*new col*/
			if(row_increment>=7)
				row_increment=7;
			row = (rand()%row_increment);		/*new row*/
			if(time_terminated<=3)
				time_terminated=3;
			delay = 1+(rand()%time_terminated);/*give a posibility to higher speed*/
			//delay ++;			/*increase difficulty*/
			move( row, col );
			addch(' ');			
		   	addstr( info->str );		
		   	addch(' ');	
			refresh();
			pthread_mutex_unlock(&mx);	/* done with curses	*/
		}
	}
}
void *ship_animate(void *arg)
{	//mvprintw(LINES-6,0,"asdf12121321321it, Rem%d",ship_col);
	struct 	propset *info = arg;		/* point to info block	*/
	int	len = strlen(info->str)+2;	/* +2 for padding	*/
	while( 1 )
	{
		usleep(info->delay*SPEED);
		pthread_mutex_lock(&mx);
		move( LINES-2, info->ship_col);	
		addstr(info->blank);			/* at a the same time	*/
		addstr(info->str);			/* Since I doubt it is	*/
		addstr(info->blank);		/* reentrant		*/
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
void *racket_animate(void *arg)
{
	struct propset *info = arg;		/* point to info block	*/
	int	col = info->ship_col+2;			/* space for padding	*/
	while( 1 )
	{
		usleep(info->delay*SPEED);
		pthread_mutex_lock(&mx);	/* only one thread	*/
		move(info->row-3, info->ship_col+2);	/* can call curses	*/
		addstr(info->blank);
		move(info->row-2, info->ship_col+2);		/* at a the same time	*/
		addstr(info->str);	
		move(info->row-1, info->ship_col+2);		/* Since I doubt it is	*/
		addstr(info->blank);			/* reentrant		*/
		move(LINES-1,COLS-1);	/* park cursor		*/
		refresh();			/* and show it		*/
	        info->row -= info->dir;
	        pthread_mutex_unlock(&mx);	/* done with curses	*/
		if (info->row == 1){
			pthread_mutex_lock(&mx);	/* only one thread	*/
			move(info->row+1, info->ship_col+2 );		/* can call curses	*/
			addch(' ');
			info->row=LINES-2; 
			info->str = "";    /*may cause blink on the next line-----------*/
			info->blank="";
			info->dir = 0;
			//addstr("88888888");		/* reentrant		*/
			move(LINES-1,COLS-1);		/* park cursor		*/
			refresh();			/* and show it		*/
			pthread_mutex_unlock(&mx);	/* done with curses	*/
			break;
		}
	}
	move( info->row, col );		/* can call curses	*/
	
}




