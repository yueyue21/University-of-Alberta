/*
 *CMPUT 379 ASSIGNMENT 3
 *STUDENT:	Yue Yin
 *ID:		1345121
 */

#include	<stdio.h>
#include	<curses.h>
#include	<pthread.h>
#include	<stdlib.h>
#include	<unistd.h>
#include	<string.h>

#define NOT_CHEAT		1			/*	1 is normal mode,
									*	0 will enable the rocket
									*	will piece throw all saucers on the straight
									*	line by 1 damage.
									*/
#define	MAXMSG			50			/* the max number of threads */
#define	SAUCER_SPEED  	60000		/* smaller, saucers faster */
#define SHIP_SPEED		5500		/*smaller, ship faster*/
#define ROCKET_SPEED	2000		/*smaller, rockets faster*/
#define SAUCERS			20			/*max number of saucers*/
#define	MISS_ALLOWED	20			/*max number of saucers player can miss*/
#define INITIAL_ROCKETS	20			/*initial number of rockets*/

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
int		game_total_fire = INITIAL_ROCKETS;
int 	game_fire = 0;		/*rackets fired in game*/

int main(int ac, char *av[])
{
	pthread_t      	thrds[MAXMSG];		/*for site and saucers*/	
	pthread_t      	fire_thrds[MAXMSG];	/*for rockets*/
	struct propset rackets[MAXMSG];
	int	       		c;					/* user input	*/	
	int	       		num_saucers ;			
	int	    		i;					/*temporary counter*/
	int				total_fire = 19; 	/*number of threads for rockets can displayed simultaneously= 20*/
	
		/**/
	/* the functions	*/
	void	       	*animate();			
	void 			*ship_animate();
	void 			*racket_animate();
	if ( ac != 1 ){						/*check running of the program*/
		printf("usage: tanimate string ..\n"); 
		exit(1);
	}
	num_saucers = setup(SAUCERS,total_fire,props,rackets,game_total_fire);
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
			if( game_fire >= game_total_fire || missed_scours >= MISS_ALLOWED ){
				sleep(1);					/*a rocket may still flying*/
				pthread_mutex_lock(&mx);			/*lock,even the last info*/
				mvprintw(LINES/2,COLS/2-9,"GAME OVER"); 
				mvprintw(LINES/2+1,COLS/2-9,"YOUR SCORE:%d",points); 
				move(LINES-1,COLS-1);		
				refresh();
				pthread_mutex_unlock(&mx);
				sleep(3);
				break;
			} 
			else{
				/*create a rocket thread*/
				if ( pthread_create(&fire_thrds[game_fire%(total_fire+1)],NULL, racket_animate, &rackets[game_fire%(total_fire+1)])){
					fprintf(stderr,"error creating thread");
					endwin();
					exit(0);
				}
				game_fire ++;	
			
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

int setup(int given_num_saucers,int total_fire, struct propset props[],struct propset rackets[],int game_total_fire)
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
	for(i=0 ; i<=num_saucers; i++){
		if (i ==0){
			props[i].str = "|";			/* the message	*/
			props[i].row = LINES-2;		/* the row	*/
			props[i].delay = 2;			/* a speed	*/
			props[i].dir = 0;
			props[i].ship_col=COLS/2;	/*initialed at mid*/
			props[i].blank = " ";		/*erase the previous site*/
			props[i].status = 0;		/*no meaning*/
			}
		else if (i<=10){
			props[i].str = "<*-*>";			/* the message	*/
			props[i].row = (rand()%4);		/* the row	*/
			props[i].delay = 1+(rand()%15);	/* a speed	*/
			props[i].dir = 1;				/* +1 or -1	*/
			props[i].ship_col=1;			/*from left side*/
			props[i].blank = " ";
			props[i].status = 2;			/*not be hit by rocket,not dead*/
			}
		else{
			props[i].str = "";				/* the message	*/
			props[i].row = (rand()%4);		/* the row	*/
			props[i].delay = 1+(rand()%15);	/* a speed	*/
			props[i].dir = 1;				/* +1 or -1	*/
			props[i].ship_col=1;			/*from left side*/
			props[i].blank = "";
			props[i].status = 0;			/*back up rockets, invisiable for their first traval accorss the screen*/
		}
	}
	for(i=0 ; i<=total_fire; i++){		/*i is [0,9]*/
		rackets[i].str = "^";			/* the rocket*/
		rackets[i].row = LINES-3;		/* the row starting at 3rd line from bottom*/
		rackets[i].delay = 10;			/* speed */
		rackets[i].dir = 1;				
		rackets[i].ship_col = COLS/2;	/*initialed at mid,same as the site*/
		rackets[i].blank = "   ";		/*3 spaces to cover the previous rocket*/
		rackets[i].status = 0;			/*no meaning*/
	}
	mvprintw(LINES-1,0,"'Q'to quit,'['or']'to move site,Remaining Rackets: %d   ",game_total_fire);
	return num_saucers;
}

/* the code that runs in each thread */
void *animate(void *arg)
{
	struct propset *info = arg;			/* point to info block	*/
	int	len = strlen(info->str)+2;		/* +2 for padding	*/
	int	col = info->ship_col;			/* space for padding	*/
	int	time_terminated=info->delay;	/*increasing the difficuilty of game*/
	int	row_increment=info->row;		/*increasing the difficuilty of game*/
	while( 1 )
	{
		usleep(info->delay*SAUCER_SPEED);

		pthread_mutex_lock(&mx);	
		move( info->row, info->ship_col );	
		addstr(info->blank);			
		addstr( info->str );				/*saucer is starting at ship_col+1*/
		addstr(info->blank);			
		move(LINES-1,COLS-1);	
		refresh();			
		pthread_mutex_unlock(&mx);	
		
	    info->ship_col += info->dir;
		if (info->ship_col+len >= COLS){
			/*increase difficulty speed of saucers*/
			time_terminated -= 3;		
			if(time_terminated<=3) time_terminated=3; 
			/*increase the row saucers will displayed*/
			row_increment += 2;			
			if(row_increment>=7) row_increment=7;
		
			pthread_mutex_lock(&mx);	
		   	move( info->row, info->ship_col );	/*erase the saucer*/	
			addstr("        ");	
			move(LINES-1,COLS-1);				/*park curcrt*/
			refresh();
			pthread_mutex_unlock(&mx);
				
			/*reinitialize saucer info in case of dead saucers*/
			if (info->status > 0) missed_scours ++;/* not dead and escaped*/
			info->status = 2;		/*respawn sausers or give 1 additional HP to 1 sausers*/
			info->ship_col = 1;					
			info->row = (rand()%row_increment);		/*new row*/
			info->delay = 1+(rand()%time_terminated);/*give a posibility to higher speed*/
			info->str = "<*-*>";				
			info->blank =" ";					
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
		move( LINES-2, info->ship_col-1);	/*leave a space for " "*/
		addch(' ');
		addch('|');
		addch(' ');
		mvprintw(LINES-1,0,"'Q'to quit,'['or']'to move site,Remaining Rackets: %d  ",game_total_fire-game_fire);
		mvprintw(LINES-1,58,"missed: %d  points: %d",missed_scours,points);
		move(LINES-1,COLS-1);		
		refresh();			
		pthread_mutex_unlock(&mx);
		
		info->ship_col+= info->dir;    /*move the site*/
		if (info->ship_col+len >= COLS || info->ship_col <= 1) info->ship_col -= info->dir;
		info->dir = 0;		/*make it stable if no keybord interuption*/
	}
}

void *racket_animate(void *arg)
{
	struct propset *info = arg;		
	int	i;
	int	col = info->ship_col;			/*must be local variable*/
	int row = info->row;				/*everytime leave original data unchanged*/
	while( 1 )
	{
		usleep(info->delay*ROCKET_SPEED);	/*sleep not quite frequently*/
		
		pthread_mutex_lock(&mx);	
		move(row-1, col-1);		
		addstr(info->blank);
		move(row, col);		
		addstr(info->str);	
		move(row+1, col-1);			/*blank has 3 spaces*/	
		addstr(info->blank);		
		move(LINES-1,COLS-1);		
		refresh();
	    pthread_mutex_unlock(&mx);
	    	
	    row -= info->dir;				/*go up a row*/
		/*check if hit the saucers first*/
		for(i=1;i<=SAUCERS;i++){  	
			if (props[i].row == row && props[i].status > 0){ /*current props[i] (sourcer is not dead)*/
				if( props[i].ship_col < info->ship_col && info->ship_col < props[i].ship_col+6 ){/* between */
					
					props[i].status -= 1;			/*HP of current saucer decreased by 1*/
					if (props[i].status <= 0){		/*saucer dead*/
						game_total_fire += 3 ;    	/*every saucer killed grants 3 rockets*/
						
						pthread_mutex_lock(&mx);
						mvprintw(row+1,info->ship_col-3,"        ");		/*remove rocket*/
						mvprintw(row,props[i].ship_col-3,"         ");		/*remove saucers*/
						move(LINES-1,COLS-1);		
						refresh();
						pthread_mutex_unlock(&mx);
						
						props[i].str ="";	
						props[i].blank = "";
						props[i].status = 0;	/*mark as dead saucer*/
						points += 4;			/*1 kill grant 4 points*/
						if(NOT_CHEAT) pthread_exit(NULL);		/*current rocket thread exits*/
					}
					else{							/*saucer still have 1 HP*/
						pthread_mutex_lock(&mx);
						mvprintw(row+1,info->ship_col-3,"       ");		/*remove rocket*/
						move(LINES-1,COLS-1);		
						refresh();
						pthread_mutex_unlock(&mx);
						
						props[i].str ="<--->";
						points += 1;			/*1 hit grant 1 points*/
						if(NOT_CHEAT) pthread_exit(NULL);		/*current rocket thread exits*/
					}
				}
			}
		}
		
		if (row <= -1){		/*for those rockets do not hit any sausers*/
			
			pthread_mutex_lock(&mx);	
			move(row-1, col-1);		
			addstr(info->blank);
			move(row, col-1);		
			addstr(info->blank);		
			move(row+1, col-1);		
			addstr(info->blank);		
			move(LINES-1,COLS-1);		
			refresh();
			pthread_mutex_unlock(&mx);
					
			pthread_exit(NULL);
			break;			/*since i doubt it*/
		}
	}
}




