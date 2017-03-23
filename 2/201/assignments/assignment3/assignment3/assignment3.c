#define _POSIX_C_SOURCE 200112L

#include <signal.h>
#include <sys/time.h>
#include <curses.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <math.h>

#define PI acos(-1.0)

// brief example of using curses.
// man 3 ncurses for introductory man page, and man 3 function name
// for more information on that function.
void handle_timeout(int signal,FILE *excutable,double ax,double ay,double bx,double by,double cx,double cy,double dx,double dy,double midx,double midy,float vy,float vx,double degree,float gravity,float thrust);
sigset_t block_mask_g;

void setup_curses();
void unset_curses();
void convert(FILE* landscape, FILE* excutable);

int main(int argc, char *argv[])
{ 
  double degree=90;
  float vy=0,vx=0;//speed of vertical and horizontal are 0 since it was static at first
  FILE *landscape,*excutable;
  double ax=310,ay=50,bx=325,by=50,cx=330,cy=70,dx=305,dy=70,midx=(ax+cx)/2,midy=(ay+cy)/2;//initialize coordinates for the ship
  //float r_upper=sqrt((midx-ax)*(midx-ax)+(midy-ay)*(midy-ay)),r_under=sqrt((midx-cx)*(midx-cx)+(midy-cy)*(midy-cy));
  //  printf("%f\n%f",r_upper,r_under);
  float gravity,thrust;

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

  for (int i=0;i<argc; i++){
    if(argv[i][0]=='-'){
      switch(argv[i][1]){
      case 'f':
	landscape=fopen(argv[i+1],"r");
      case 'g':
	gravity=atof(argv[i+1]);
      case 't':
	thrust=atof(argv[i+1]);
      }	
    }
  }
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
	{
	  // in asn3, won't need to do any printing to screen.
	  // instead, will rotate figure on left or right arrow keys, and
	  // initiate thrust when space bar is pressed.
	  erase();
	  move(5,10);
	  printw("Press arrow keys, 'q' to quit.");
	  move(6, 10);
	  if (c == KEY_DOWN)
	    printw("down key pressed");
	  else if (c == KEY_LEFT){
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
	    //printf("%f\n",ax);
	    //printf("left key pressed %ld %ld %ld %ld %ld %ld %ld %ld\n",lround(ax),lround(ay),lround(bx),lround(by),lround(cx),lround(cy),lround(dx),lround(dy));
	    fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(ax),lround(ay),lround(bx),lround(by));
	    fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(bx),lround(by),lround(cx),lround(cy));
	    fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(cx),lround(cy),lround(dx),lround(dy));
	    fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(dx),lround(dy),lround(ax),lround(ay));
	    fflush(excutable);
	  }
	  else if (c == KEY_RIGHT){ 
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
	    //printf("%f\n",ax);
	    //printf("left key pressed %ld %ld %ld %ld %ld %ld %ld %ld\n",lround(ax),lround(ay),lround(bx),lround(by),lround(cx),lround(cy),lround(dx),lround(dy));
	    fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(ax),lround(ay),lround(bx),lround(by));
	    fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(bx),lround(by),lround(cx),lround(cy));
	    fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(cx),lround(cy),lround(dx),lround(dy));
	    fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(dx),lround(dy),lround(ax),lround(ay));
	    fflush(excutable);
	  }
	  else if (c == KEY_UP)
	    printw("up key pressed");
	  else if (c == 'q'){
	    fprintf(excutable,"end\n");
	    break;
	  }
	  refresh();

	}
      
      c = getch();
      
    }
  
  // must do this or else Terminal will be unusable
  // (if there are problems, it's not that big a deal though ... just
  // close the Terminal, and open a new one.)
  unset_curses();
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
  fprintf(excutable,"drawSegment 310 50 325 50\n");
  fprintf(excutable,"drawSegment 325 50 330 70\n");
  fprintf(excutable,"drawSegment 330 70 305 70\n");
  fprintf(excutable,"drawSegment 305 70 310 50\n");
  fflush(excutable);
}

void handle_timeout(int signal,FILE *excutable,double ax,double ay,double bx,double by,double cx,double cy,double dx,double dy,double midx,double midy,float vy,float vx,double degree,float gravity,float thrust)
{
  static int called = 0;

  called++;

  // called because of SIGALRM
  if (signal == SIGALRM)
  {

    // gets timer, puts it into timer (man 2 getitimer)
    struct itimerval timer;
    if (getitimer(ITIMER_REAL, &timer) == -1)
      exit(EXIT_FAILURE);
    
    printf("called: %d\n", called);
    fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(ax),lround(ay),lround(bx),lround(by));
    fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(bx),lround(by),lround(cx),lround(cy));
    fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(cx),lround(cy),lround(dx),lround(dy));
    fprintf(excutable,"eraseSegment %ld %ld %ld %ld\n",lround(dx),lround(dy),lround(ax),lround(ay));
    float ychange=(gravity-thrust*sin(degree*(PI/180)))/800+vy/20;
    float xchange=(thrust*cos(degree*(PI/180)))/800+vx/20;
    fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(ax+xchange),lround(ay+ychange),lround(bx+xchange),lround(by+ychange));
    fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(bx+xchange),lround(by+ychange),lround(cx+xchange),lround(cy+ychange));
    fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(cx+xchange),lround(cy+ychange),lround(dx+xchange),lround(dy+ychange));
    fprintf(excutable,"drawSegment %ld %ld %ld %ld\n",lround(dx+xchange),lround(dy+ychange),lround(ax+xchange),lround(ay+ychange));
    //fflush(excutable);
    // stops timer on 5th call.  In asn3, you should do this when the
    // game is done (e.g., ship has crashed or landed)
    if (called == 60)
      {
	// in asn3, you should use tv_usec
      timer.it_interval.tv_sec = 0;
      timer.it_value.tv_sec = 0;
      //exit(EXIT_SUCCESS);
      }   
    
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
