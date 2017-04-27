#include <stdio.h>

#define SCALE_FACTOR (5.0f/9.0f)
#define FREEZING_PT 32.0f

int main(void){
  float fahrenheit, celsius;
  printf("Enter fahrenheit temperature:");

  scanf("%f",&fahrenheit);
  
  celsius = (fahrenheit - FREEZING_PT) * SCALE_FACTOR;

  printf("Celsius is %.1f\n",celsius);

  return 0;
}
