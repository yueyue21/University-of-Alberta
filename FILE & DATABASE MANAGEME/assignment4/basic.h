#ifndef BASIC_H
#define BASIC_H
#define DA_FILE  "/tmp/my_db/sample_db"   
#define DB_SIZE   1000
# include <stdlib.h>
# include <string.h>
# include <db.h>

int initial_choice=0;
void btree_interface();
void btree();
void key_search();
void data_search();
#endif

