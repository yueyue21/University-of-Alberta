#define _POSIX_C_SOURCE 200112L
#include <unistd.h>
#include <signal.h>
#include <sys/time.h>
#include <curses.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <math.h>
#include "assignment3.h"
#define PI acos(-1.0)

int main(int argc, char *argv[])
{ 
  int option;
  while ((option = getopt (argc, argv, "-t:f:g:i")) != -1)
    switch (option)
      {
      case 'f':
	landscape=fopen(optarg,"r");	
	break;
      case 'g':
	gravity=atof(optarg);
	break;
      case 't':
	thrust=atof(optarg);
	break;
      case 'i':
	improve=1;
	break;
      }
  
  /*  for (int i=0;i<argc; i++){
  //printf("hello");
  if(argv[i][0]=='-'){
  switch(argv[i][1]){
  case 'f':{
  landscape=fopen(argv[i+1],"r");	
  printf("asdfasdfa");}
  case 'g':
  gravity=atof(argv[i+1]);
  //printf("%s",argv[i+1]);
  //gravity=9.8;
  //printf("hello");
  //printf("%f", gravity);
  case 't':
  thrust=atof(argv[i+1]);
  //thrust=25.0;
  }	
  }
  }*/
  
  sigemptyset(&block_mask_g); 
  sigaddset(&block_mask_g, SIGALRM);
  struct sigaction handler;
  handler.sa_handler = handle_timeout;
  sigemptyset(&handler.sa_mask);
  handler.sa_flags = 0;
  if (sigaction(SIGALRM, &handler, NULL) == -1)
    exit(EXIT_FAILURE);
  struct itimerval timer;
  struct timeval time_delay;
  time_delay.tv_sec = 0;
  time_delay.tv_usec = 50000;
  timer.it_interval = time_delay;
  struct timeval start;
  start.tv_sec = 0;
  start.tv_usec = 50000;
  timer.it_value = start;
  if (setitimer(ITIMER_REAL, &timer, NULL) == -1)
    exit(EXIT_FAILURE);
  //  for ( ; ; )
  //    ;
  //  exit(EXIT_SUCCESS);
  // printf("hello");
    
  excutable=popen("java -jar Sketchpad.jar","w");
  convert(landscape,excutable);
  setup_curses();
    
  move(5, 10);
  printw("Press any key to start.");
  refresh();
  int c = getch();
  
  nodelay(stdscr, true);
  erase();
  
  move(5, 10);
  printw("Press arrow keys, 'q' to quit.");
  refresh();
  
  c = getch();
  
  while(1)
    {
      if (c != ERR)
	{midx=(ax+cx)/2;
	  midy=(ay+cy)/2;
	  // in asn3, won't need to do any printing to screen.
	  // instead, will rotate figure on left or right arrow keys, and
	  // initiate thrust when space bar is pressed.
	  
	  erase();
	  move(5,10);
	  printw("Press arrow keys, 'q' to quit.");
	  move(6, 10);
	  fprintf(excutable,"setColor 200 130 0\n");
	  if (c == KEY_DOWN)
	    printw("down key pressed");
	  else if (c == KEY_LEFT && stop==0 && E==0){
	    printw("left key pressed");
	    degree+=10;
	    
	    fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(ax),lround(ay),lround(bx),lround(by));
	    fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(bx),lround(by),lround(cx),lround(cy));
	    fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(cx),lround(cy),lround(dx),lround(dy));
	    fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(dx),lround(dy),lround(ax),lround(ay));
	    float temp_x=midx+(((ax-midx)*cos(-PI/18))- ((ay-midy) * sin(-PI/18)));
            ay = midy+(((ax-midx) * sin(-PI/18)) + ((ay-midy) * cos(-PI/18)));
	    ax=temp_x;
	    
	    temp_x = midx+(((bx-midx) * cos(-PI/18)) - ((by-midy) * sin(-PI/18)));
            by = midy+(((bx-midx) * sin(-PI/18)) + ((by-midy) * cos(-PI/18)));
	    bx=temp_x;
	    
	    temp_x = midx+((cx-midx) * cos(-PI/18)) - ((cy-midy) * sin(-PI/18));
            cy = midy+((cx-midx) * sin(-PI/18) + (cy-midy) * cos(-PI/18));
	    cx=temp_x;
	    
	    temp_x = midx+(((dx-midx) * cos(-PI/18)) - ((dy-midy) * sin(-PI/18)));
            dy = midy+(((dx-midx) * sin(-PI/18)) + ((dy-midy) * cos(-PI/18)));
	    dx=temp_x;
	    fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(ax),lround(ay),lround(bx),lround(by));
	    fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(bx),lround(by),lround(cx),lround(cy));
	    fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(cx),lround(cy),lround(dx),lround(dy));
	    fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(dx),lround(dy),lround(ax),lround(ay));
	    fflush(excutable);
	  }
	  else if (c == KEY_RIGHT && stop == 0 && E ==0){ 
	    printw("right key pressed");
	    degree+= -10;
	    fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(ax),lround(ay),lround(bx),lround(by));
	    fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(bx),lround(by),lround(cx),lround(cy));
	    fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(cx),lround(cy),lround(dx),lround(dy));
	    fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(dx),lround(dy),lround(ax),lround(ay));
	    float temp_x=midx+(((ax-midx)*cos(PI/18))- ((ay-midy) * sin(PI/18)));
            ay = midy+(((ax-midx) * sin(PI/18)) + ((ay-midy) * cos(PI/18)));
	    ax=temp_x;
	    
	    temp_x = midx+(((bx-midx) * cos(PI/18)) - ((by-midy) * sin(PI/18)));
            by = midy+(((bx-midx) * sin(PI/18)) + ((by-midy) * cos(PI/18)));
	    bx=temp_x;
	    
	    temp_x = midx+((cx-midx) * cos(PI/18)) - ((cy-midy) * sin(PI/18));
            cy = midy+((cx-midx) * sin(PI/18) + (cy-midy) * cos(PI/18));
	    cx=temp_x;
	    
	    temp_x = midx+(((dx-midx) * cos(PI/18)) - ((dy-midy) * sin(PI/18)));
            dy = midy+(((dx-midx) * sin(PI/18)) + ((dy-midy) * cos(PI/18)));
	    dx=temp_x;
	    fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(ax),lround(ay),lround(bx),lround(by));
	    fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(bx),lround(by),lround(cx),lround(cy));
	    fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(cx),lround(cy),lround(dx),lround(dy));
	    fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(dx),lround(dy),lround(ax),lround(ay));
	    fflush(excutable);
	  }
	  else if (c == ' '&&stop ==0){
	    // example_of_blocking_a_signal();
	    T = 1;
	    if(improve==1)
	      fuel = fuel-1;
            
	    printw("space key pressed %f",thrust1);
	    /*fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(cx),lround(cy),lround(cx+dx-midx),lround(cy+dy-midy));
	      fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(cx+dx-midx),lround(cy+dy-midy),lround(dx),lround(dy));*/
	    thrust1=thrust;
	  }
	  else if (c == 'q'){
	    fprintf(excutable,"end\n");
	    unset_curses();
	    exit(EXIT_SUCCESS);	
	    //break;
	  }
	  refresh();
	}
      
      c = getch();
      
    }
  
  // must do this or else Terminal will be unusable
  // (if there are problems, it's not that big a deal though ... just
  // close the Terminal, and open a new one.)
  
  // pclose(excutable);//file closed  
  exit(EXIT_SUCCESS);		
}

void setup_curses(){
  // use return values.  see man pages.  likely just useful for error
  // checking (NULL or non-NULL, at least for init_scr)
  initscr();
  cbreak();
  noecho();
  // needed for cursor keys (even though says keypad)
  keypad(stdscr, true);
}

void unset_curses()
{
  keypad(stdscr, false);
  nodelay(stdscr, false);
  nocbreak();
  echo();
  endwin();
}

void convert(FILE* landscape, FILE* excutable)
{
  char line[128];
  int current_line=1;
  int prex,prey,currentx,currenty;
  while(fgets(line, 128, landscape) != NULL){
    fprintf(excutable,"setColor 34 108 107\n");
    if (current_line == 1){
      sscanf(line, "%d%d",&prex,&prey);
      current_line ++;
    }
    else if (current_line == 2){
      current_line ++;
      if(sscanf(line, "%d%d",&currentx,&currenty)==2){
	fprintf(excutable,"drawSegment %d %d %d %d\n",prex,prey,currentx,currenty);
      }
    }	
    else{// after the seconde line
      prex=currentx;
      prey=currenty;
      if(sscanf(line, "%d%d",&currentx,&currenty)==2){
	fprintf(excutable,"drawSegment %d %d %d %d\n",prex,prey,currentx,currenty);
      }
    }
  }
  fprintf(excutable,"setColor 200 130 0\n");
  fprintf(excutable,"drawSegment 310 50 325 50\n");
  fprintf(excutable,"drawSegment 325 50 330 70\n");
  fprintf(excutable,"drawSegment 330 70 305 70\n");
  fprintf(excutable,"drawSegment 305 70 310 50\n");
  fflush(excutable);
}

void handle_timeout(int signal)
{
  static int called = 0;

  called++;
  
  // called because of SIGALRM
  if (signal == SIGALRM)
    {
      /*fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(cx),lround(cy),lround(cx+dx-midx),lround(cy+dy-midy));
	fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(cx+dx-midx),lround(cy+dy-midy),lround(dx),lround(dy));*/
      //fflush(excutable);
      
      // gets timer, puts it into timer (man 2 getitimer)
      struct itimerval timer;
      if (getitimer(ITIMER_REAL, &timer) == -1)
	exit(EXIT_FAILURE);
      //check 
      if(improve==1){
      if(fuel<=0){
	thrust1=0;
	fuel=0;
      	}
   	}
      /*fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(cx),lround(cy),lround(cx+dx-midx),lround(cy+dy-midy));
	fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(cx+dx-midx),lround(cy+dy-midy),lround(dx),lround(dy));*/
      vy = vy +gravity*0.05-thrust1*sin(degree*(PI/180))*0.05;
      vx = vx +(thrust1*cos(degree*(PI/180)))/20;
      float ychange=(gravity-thrust1*sin(degree*(PI/180)))*0.5*0.0025+vy*0.05;
      float xchange=(thrust1*cos(degree*(PI/180)))*0.5*0.0025+vx*0.05;
      thrust1=0;
      if(ax>=630 ||bx>=630||cx>=630||dx>=630)
	vx=0;
      if(ay>=395 || by>=395 || cy >=395 || dy >= 395){
	stop=1;
	move(8,10);
	if(cx>400 || dx<200)
		printw("not at proper place,crashed!");
	else{
		if (vy<=15 && degree%360==90)
			printw("lastspeed=%f,successfully landed!",vy);
		else 
			printw("lastspeed=%f,ops,crashed!",vy);
	}	
	gravity=0;
	thrust1=0;
      }

      //fire
      fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(cx),lround(cy),lround(cx+dx-(ax+cx)/2),lround(cy+dy-(ay+cy)/2));
      fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(cx+dx-(ax+cx)/2),lround(cy+dy-(ay+cy)/2),lround(dx),lround(dy));
      fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(cx),lround(cy),lround(cx+dx-(ax+bx)/2),lround(cy+dy-(ay+by)/2));
      fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(cx+dx-(ax+bx)/2),lround(cy+dy-(ay+by)/2),lround(dx),lround(dy));
      fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(cx),lround(cy),lround(cx+dx-(ax+bx)/2-5),lround(cy+dy-(ay+by)/2-5));
      fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(cx+dx-(ax+bx)/2-5),lround(cy+dy-(ay+by)/2-5),lround(dx),lround(dy));
      fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(cx),lround(cy),lround(cx+dx-(ax+bx)/2+5),lround(cy+dy-(ay+by)/2+5));
      fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(cx+dx-(ax+bx)/2+5),lround(cy+dy-(ay+by)/2+5),lround(dx),lround(dy));
      E=0;
      if(stop ==0){
      fprintf(excutable,"setColor 200 130 0\n");
      fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(ax),lround(ay),lround(bx),lround(by));
      fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(bx),lround(by),lround(cx),lround(cy));
      fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(cx),lround(cy),lround(dx),lround(dy));
      fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(dx),lround(dy),lround(ax),lround(ay));
    
      move(7,10);
      if (improve==1)
	printw("g=%f,vy=%f,vx=%f,fuel=%d,degree=%d",gravity,vy,vx,fuel,degree);
      else if(improve == 0)
	printw("g=%f,vy=%f,vx=%f,degree=%d",gravity,vy,vx,degree);
      fflush(excutable);
      ax=ax+xchange;
      ay=ay+ychange;
      bx=bx+xchange;
      by=by+ychange;
      cx=cx+xchange;
      cy=cy+ychange;
      dx=dx+xchange;
      dy=dy+ychange;
      fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(ax),lround(ay),lround(bx),lround(by));
      fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(bx),lround(by),lround(cx),lround(cy));
      fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(cx),lround(cy),lround(dx),lround(dy));
      fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(dx),lround(dy),lround(ax),lround(ay));
    
      if(T==1 && fuel>0){
	if(improve ==1){
	if(fuel<125 && r<252)
	  r=r+2;
	else if(fuel>=125 && g>20)
	  g=g-2;
	fprintf(excutable,"setColor %d %d %d\n",r,g,b);
	}
	else if(improve == 0)
		fprintf(excutable,"setColor 175 0 0\n");
	fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(cx),lround(cy),lround(cx+dx-(ax+cx)/2),lround(cy+dy-(ay+cy)/2));
	fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(cx+dx-(ax+cx)/2),lround(cy+dy-(ay+cy)/2),lround(dx),lround(dy));
	fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(cx),lround(cy),lround(cx+dx-(ax+bx)/2),lround(cy+dy-(ay+by)/2));
	fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(cx+dx-(ax+bx)/2),lround(cy+dy-(ay+by)/2),lround(dx),lround(dy));
	fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(cx),lround(cy),lround(cx+dx-(ax+bx)/2-5),lround(cy+dy-(ay+by)/2-5));
	fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(cx+dx-(ax+bx)/2-5),lround(cy+dy-(ay+by)/2-5),lround(dx),lround(dy));
	fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(cx),lround(cy),lround(cx+dx-(ax+bx)/2+5),lround(cy+dy-(ay+by)/2+5));
	fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(cx+dx-(ax+bx)/2+5),lround(cy+dy-(ay+by)/2+5),lround(dx),lround(dy));
	E=1;//erase required before rotating!   
	T=0;
      }
	}
      fflush(excutable);
      // stops timer on 5th call.  In asn3, you should do this when the
      // game is done (e.g., ship has crashed or landed)
      /* if (called == 60)
	 {
	 // in asn3, you should use tv_usec
	 timer.it_interval.tv_sec = 0;
	 timer.it_value.tv_sec = 0;
	 //exit(EXIT_SUCCESS);
	 }   */
    
      if (setitimer(ITIMER_REAL, &timer, NULL) == -1)
	exit(EXIT_FAILURE);
    }
  
}

void example_of_blocking_a_signal()
{
  // remember old list of signals to block (none, in our case)
  sigset_t old_mask;
  // set blocked signal set to block_mask_g (man 2 sigprocmask).
  // so now block SIGALRM.
  if (sigprocmask(SIG_BLOCK, &block_mask_g, &old_mask) < 0)
    exit(EXIT_FAILURE);

  // CRITICAL CODE GOES HERE ... can call other functions here, and
  // they will not be interrupted

  // unblock signal by setting mask to old value (which in our
  // case wasn't blocking anything)
  if (sigprocmask(SIG_SETMASK, &old_mask, NULL) < 0)
    exit(EXIT_FAILURE);
}


