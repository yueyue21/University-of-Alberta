for(i=0; i<racket;i ++){
		if ( pthread_create(&rak_thrds[i], NULL, racket_animate, &racktes[i])){
			fprintf(stderr,"error creating thread");
			endwin();
			exit(0);
		}
	}
	






void *racket_animate(void *arg)
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
