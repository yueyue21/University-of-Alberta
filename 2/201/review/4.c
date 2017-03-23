#include <stdio.h>
int main(void){
	struct item{
		int itemNo;
		double price;
		double quantity;		
	};
/*	typedef struct{
		int itemNo;
		double price;
		double quantity;		
	}item;
*/
	struct item ita;
	item itb;
	item item1 = {12345,56.23,253};//initialization
	item item2;
	item2 = item1;

	
}
