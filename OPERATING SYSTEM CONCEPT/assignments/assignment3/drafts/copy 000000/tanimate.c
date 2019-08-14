/*
 * tanimate.c: animate several strings using threads, curses, usleep()
 *
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

#define	MAXMSG			50			/* the max number of threads */
#define	SAUCER_SPEED  	80000		/* smaller, saucers faster */
#define SHIP_SPEED		5500		/*smaller, ship faster*/
#define ROCKET_SPEED	2000		/*smaller, rockets faster*/
#define SAUCERS			15			/*number of saucers*/
#define	MISS_ALLOWED	10			/*max number of saucers player can miss*/
#define INITIAL_ROCKETS	50			/*initial number of rockets*/

struct	propset {
		char	*str;	/* the message */
		char	*blank; /* "   "*/
		int		row;	/* the row     */
		int		delay;  /* delay in time units */
		int		dir;	/* +1 or -1	*/
		int		ship_col;
		int		status;	/*only used for saucers,0 is not dead*/
	};
	
pthread_mutex_t mx = PTHREAD_MUTEX_INITIALIZER;
struct propset 	props[MAXMSG];
int		missed_scours=0;
int		points=0;			/*score*/

int main(int ac, char *av[])
{
	pthread_t      	thrds[MAXMSG];		/*for site and saucers*/	
	pthread_t      	fire_thrds[MAXMSG];	/*for rockets*/
	struct propset rackets[MAXMSG];
	int	       		c;					/* user input	*/	
	int	       		num_saucers ;			
	int	    		i;					/*temporary counter*/
	int				total_fire=9; 		/*number of threads for rockets = 10*/
	int 			game_fire=0;		/*rackets fired in game*/
	int				game_total_fire=INITIAL_ROCKETS;	/**/
	/* the functions	*/
	void	       	*animate();			
	void 			*ship_animate();
	void 			*racket_animate();
	if ( ac != 1 ){						/*check running of the program*/
		printf("usage: tanimate string ..\n"); 
		exit(1);
	}
	num_saucers = setup(SAUCERS,total_fire,props,rackets);
	/* create the saucer threads */
	for(i=1 ; i<num_saucers; i++)
		if ( pthread_create(&thrds[i], NULL, animate, &props[i])){
			fprintf(stderr,"error creating thread");
			endwin();
			exit(0);
	}
	/*create the thread of ship*/
	if ( pthread_create(&thrds[0], NULL, ship_animate, &props[0])){
		fprintf(stderr,"error creating thread");
		endwin();
		exit(0);
	}
	/* process user input */
	while(1) {
		c = getch();
		if (c == 'Q' ) break;
		if (c == '[') props[0].dir= -1;
		if (c == ']') props[0].dir=1;
		if (c == ' ' ){
			for (i=0; i<=total_fire; i++ ){
				rackets[i].ship_col=props[0].ship_col;
			}
			if ( game_fire <=game_total_fire && missed_scours <= MISS_ALLOWED ){
				/*create a rocket thread*/
				if ( pthread_create(&fire_thrds[game_fire%(total_fire+1)],NULL, racket_animate, &rackets[game_fire%(total_fire+1)])){
					fprintf(stderr,"error creating thread");
					endwin();
					exit(0);
				}
				mvprintw(LINES-1,0,"'Q'to quit,'['or']'to move site,Remaining Rackets: %d  ",game_total_fire-game_fire);
				move(LINES-1,COLS-1);		
				refresh();
				game_fire ++;
			}	
			else{
				mvprintw(LINES/2,COLS/2-5,"GAME OVER");
				sleep(3);
				break;
			} 
		}
	}

	/* cancel all the threads */
	pthread_mutex_lock(&mx);
	for (i=0; i<num_saucers; i++ )
		pthread_cancel(thrds[i]);
	for (i=0; i<total_fire; i++ )
		pthread_cancel(fire_thrds[i]);
	endwin();
	return 0;
}

int setup(int given_num_saucers,int total_fire, struct propset props[],struct propset rackets[])
{
	int num_saucers = ( given_num_saucers > MAXMSG ? MAXMSG : given_num_saucers );
	int i;
	/* set up curses */
	initscr();
	crmode();
	noecho();
	clear();
	/* assign rows and velocities to each string */
	srand(getpid());
	for(i=0 ; i<num_saucers; i++){
	if (i ==0){
		props[i].str = "|";			/* the message	*/
		props[i].row = LINES-2;		/* the row	*/
		props[i].delay = 2;			/* a speed	*/
		props[i].dir = 0;
		props[i].ship_col=COLS/2;	/*initialed at mid*/
		props[i].blank = " ";		/*erase the previous site*/
		props[i].status=0;			/*no meaning*/
		}
	else{
		props[i].str = "<--->";			/* the message	*/
		props[i].row = (rand()%5);		/* the row	*/
		props[i].delay = 1+(rand()%13);	/* a speed	*/
		props[i].dir = 1;				/* +1 or -1	*/
		props[i].ship_col=1;			/*from left side*/
		props[i].blank = " ";
		props[i].status=0;				/*not be hit by rocket,not dead*/
		}
	}
	for(i=0 ; i<=total_fire; i++){		/*i is [0,9]*/
		rackets[i].str = "^";			/* the rocket*/
		rackets[i].row = LINES-3;		/* the row starting at 3rd line from bottom*/
		rackets[i].delay = 10;			/* speed */
		rackets[i].dir = 1;				
		rackets[i].ship_col=COLS/2;		/*initialed at mid,same as the site*/
		rackets[i].blank = "   ";		/*3 spaces to cover the previous rocket*/
		rackets[i].status=0;			/*no meaning*/
	}
	mvprintw(LINES-1,0,"'Q'to quit,'['or']'for moving site,Remaining Rackets: 20    ");
	return num_saucers;
}

/* the code that runs in each thread */
void *animate(void *arg)
{
	struct propset *info = arg;		/* point to info block	*/
	int	len = strlen(info->str)+2;		/* +2 for padding	*/
	int	col = info->ship_col;			/* space for padding	*/
	int	row = info->row;
	int	delay = info->delay;
	int	time_terminated=info->delay;	/*increasing the difficuilty of game*/
	int	row_increment=info->row;	/*increasing the difficuilty of game*/
	while( 1 )
	{
		usleep(delay*SAUCER_SPEED);

		pthread_mutex_lock(&mx);	
		   move( info->row, info->ship_col );	
		   addstr(info->blank);			
		   addstr( info->str );		
		   addstr(info->blank);			
		   move(LINES-1,COLS-1);	
		   refresh();			
		   pthread_mutex_unlock(&mx);	
	           info->ship_col += info->dir;
		if (info->ship_col+len >= COLS){
			if (info->status == 0){ /*not dead*/
				missed_scours ++;
			}
			else{
				info->status = 0;		/*respawn the soursers*/
			}
			time_terminated-=3;		/*increase difficulty*/
			row_increment+=2;
			pthread_mutex_lock(&mx);	
		   	move( info->row, info->ship_col );		
			addstr("       ");					
			info->ship_col = 1;			/*new col*/
			if(row_increment>=7)
				row_increment=7;
			row = (rand()%row_increment);		/*new row*/
			if(time_terminated<=3)
				time_terminated=3;
			delay = 1+(rand()%time_terminated);/*give a posibility to higher speed*/
			info->str = "<--->";
			info->blank =" ";
			move( info->row, info->ship_col);
			addch(' ');				
		   	addch(' ');	
			refresh();
			pthread_mutex_unlock(&mx);	/* done with curses	*/
		}
	}
}
void *ship_animate(void *arg)
{	
	struct 	propset *info = arg;		/* point to info block	*/
	int	len = strlen(info->str)+2;	
	while( 1 )
	{
		usleep(info->delay*SHIP_SPEED);
		pthread_mutex_lock(&mx);
		move( LINES-2, info->ship_col);	
		addch(' ');
		addch('|');
		addch(' ');
		move(LINES-1,COLS-1);		
		refresh();			
		pthread_mutex_unlock(&mx);
		info->ship_col+= info->dir;
		
		mvprintw(LINES-1,58,"missed: %d  points: %d",missed_scours,points);
		move(LINES-1,COLS-1);		
		refresh();   
		if (info->ship_col+len >= COLS || info->ship_col <= 1){
			info->ship_col-= info->dir;
		}
		info->dir = 0;		/*make it stable if no keybord interuption*/
	}
}
void *racket_animate(void *arg)
{
	struct propset *info = arg;		
	int	i;
	int	col = info->ship_col+1;			/*must be local variable*/
	while( 1 )
	{
		usleep(info->delay*ROCKET_SPEED);
		pthread_mutex_lock(&mx);	
		move(info->row-1, col-1);		
		addstr(info->blank);
		move(info->row, col);		
		addstr(info->str);	
		move(info->row+1, col-1);		
		addstr(info->blank);		
		move(LINES-1,COLS-1);		
		refresh();
		info->row -= info->dir;
	    pthread_mutex_unlock(&mx);	
		if (info->row <=1){
			info->str = "";
			pthread_mutex_lock(&mx);	
			move(info->row-1, col-1);		
			addstr(info->blank);
			move(info->row, col);		
			addstr(info->blank);		/*draw a " " at rocket*/
			move(info->row+1, col-1);		
			addstr(info->blank);		
			move(LINES-1,COLS-1);		
			refresh();
			pthread_mutex_unlock(&mx);
			info->row=LINES-3; 
			info->str = "^";		
			pthread_exit(NULL);
			break;
		}
		for(i=1;i<=SAUCERS;i++){  	
			if (props[i].row==info->row && props[i].status == 0){ /*current props[i] (sourcer is not dead)*/
				if( props[i].ship_col < info->ship_col+1 && info->ship_col+1 < props[i].ship_col+6 ){
					pthread_mutex_lock(&mx);
					mvprintw(info->row-1,info->ship_col+1," ");
					mvprintw(info->row,info->ship_col-4,"          ");
					move(LINES-1,COLS-1);		
					refresh();
					pthread_mutex_unlock(&mx);
					info->str= "";
					props[i].str ="";	
					props[i].blank = "";
					props[i].status = 1;	
					points ++;
					pthread_exit(NULL);
				}
			}
		}
	}
	
	
}




