/*
 * 
 *
 */

# include "basic.h"

#define DA_FILE  "/tmp/my_db/sample_db"   
#define DB_SIZE   1000
DB *db;
int main(int argc, char *argv[]) {
  /*int i;
    for(i=0;i<argc;i++){
    switch(argv[1]){
    case "btree":
    initial_choice = 1;
    case "hash":
    initial_choice = 2;
    case "index":		
    initial_choice = 3;
    }
    }
    if(initial_choice ==1)*/
  btree_interface();
  return 0;
}

void btree_interface(){
  printf("MAIN MENU:\n1. Create and populate the database\n2. Retrieve records with a given key\n3. Retrieve records with a given data\n4. Retrieve records with a given range of key values\n5. Destroy the database\n6. Quit\n");
  char choice1[5];
  printf("Enger a choice:");
  scanf("%s",choice1);
  int ret;
  if(choice1[0] == '1'){
    btree();
    return btree_interface();
  }
  else if(choice1[0] =='2'){
    key_search();
    return btree_interface();
  }
  else if(choice1[0]=='3'){
    data_search();
    return btree_interface();	
  }
  else if(choice1[0]=='6')
    return ;
  else
    printf("Wrong input,try again.\n");
  return btree_interface();		
}

void btree(){//choice1
  int ret,range,index,i;
  DBT key, data;
  unsigned seed;
  char keybuff[128];
  char databuff[128];

  /*
   *  to create a db handle
   */
  if ( (ret = db_create(&db, NULL, 0)) != 0 ) {
    printf("db_create: %s\n", db_strerror(ret));
    exit(1);
  }

  /*
   *  to open the db
   */
  ret = db->open(db,NULL,DA_FILE,NULL,DB_BTREE,DB_CREATE,0);
  if (ret != 0) {
    printf("DB doesn't exist, creating a new one: %s\n", db_strerror(ret));
    exit(1);
  }

  memset(&key, 0, sizeof(key));
  memset(&data, 0, sizeof(data));
 
  /*
   *  to seed the random number after db openning, and see it once.
   */
  seed = 10000000;
  srand(seed);

  /*
   *  to populate the database
   */
  for (index=0;index<DB_SIZE;index++)  {

    // to generate the key string
    range=64+random()%(64);
    for (i=0; i<range;i++)
      keybuff[i]= (char)(97+random()%26);
    keybuff[range]=0;
       
    key.data = keybuff; 
    key.size = range; 

    // to generate the data string
    range=64+random()%(64);
    for (i=0;i<range;i++)
      databuff[i]= (char) (97+random()%26);
    databuff[range]=0;

    data.data=databuff;
    data.size=range;

    // You may record the key/data string for testing
    printf("%s\n",(char *)key.data); printf("%s\n\n",(char *)data.data);

    // to insert the key/data pair into the db
    if (ret=db->put(db, NULL, &key, &data, 0))
      printf("DB->put: %s\n", db_strerror(ret));
  }
    
  /*
   *  to close the database
   */
  //if (ret = db->close(db,0))
  //  printf("DB->close: %s\n", db_strerror(ret));
}

void key_search(){//choice 2
  DBT* key;
	DBT* data;
  int ret;
  printf("Enter the key for a record:");
  char temp_key[129];
  scanf("%s",temp_key);
  printf("\n\n----------%s",temp_key);
  
	key=(DBT*)malloc(sizeof(key));
	data=(DBT*)malloc(sizeof(data));
  memset(key,0,sizeof(key));	
  memset(data,0,sizeof(data));
  key->data = temp_key;
  key->size=strlen(temp_key)+1;

  printf("\n\nKey: %.*s\n",key->size,key->data);
	
	if (!db)
  	if(db->open(db,NULL,DA_FILE,NULL,DB_BTREE,0,0))/////////////////DO I NEED TO REOPEN THE DATABASE AGAIN?   PROBLEM WITH DB GET
  		printf("db->open %s\n",db_strerror(ret));
	//printf("b4 db->get\n");
  if(ret = (db->get(db,NULL,key,data,0)))
    printf("%s\n",db_strerror(ret));
  exit(1);
  printf("%s",(char*)key->data);
  free(key);
  free(data);
}

void data_search(){//choice3
  DBT key, data;
  printf("Enger the data for a record:");
  char temp_data[sizeof(data)];
  scanf("%s",temp_data);
  printf("%s",temp_data);
  memset(&key,0,sizeof(key));	
  memset(&data,0,sizeof(data));
  data.data = temp_data;
  data.size = sizeof(data)+1;
  db->get(db,NULL,&key,&data,0);
  printf("%s",(char*)data.data);	
}
