if (c == ' ' ){
			if( fire <total_fire){
			rackets[fire].ship_col=props[0].ship_col;
			pthread_create(&fire_thrds[fire], NULL, racket_animate, &rackets[fire]);
			fire ++;
			mvprintw(LINES-1,0,"'Q' to quit, Remaining Rackets: %d  Number of Saucers missed: %d",total_fire-fire,rackets[fire].ship_col);
			}
			else if (fire == total_fire){	/*last rocket*/
				rackets[fire].ship_col=props[0].ship_col;
				pthread_create(&fire_thrds[fire], NULL, racket_animate, &rackets[fire]);
				sleep(1);
				mvprintw(LINES/2,COLS/2,"GAME OVER(running out of rockets)");
				move(LINES-1,COLS-1);
				fire ++;
				sleep(1);
				
			}
			else {//if(fire <= total_fire){/*--------------- problem--*/
				break;
			}
