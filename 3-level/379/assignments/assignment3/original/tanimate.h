
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