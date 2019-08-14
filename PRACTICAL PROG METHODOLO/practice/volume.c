#include <stdio.h>
int main(void){
  int height,length,width,volume,weight;
  float profit;

  profit = 2.4234234234;
  height = 8;
  length = 12;
  width = 10;
  volume = height * length * width;
  weight = (volume +165)/166;

  volume = height * length * width;
  printf("Height: %d\n", height); 
  printf("Length: %d\n", length); 
  printf("width: %d\n", width); 
  printf("profit: $%.3f\n", profit); 
  printf("profit: $%.2f\nLength: %dm\n", profit, length); 
  printf("Dimensions :%dx%dx%d\n",length, width, height);
  printf("Volume (cubic inces):%d\n",volume);
  printf("Dimensional weight (pounds):%d\n", weight);

  return 0; 

}
