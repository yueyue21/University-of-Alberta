char *start = (char*)0x00000000;
char *end = (char*)0xfffff000;
int p,a,b;	
int chunk_number = -1;/* special initialization*/
int last = 0; //last indicating the last chunk of scanning
int pre_not_read=1;//indicating previous page is not readable
int pre_not_write=1;//indicating previous page is readable but not writeable
static sigjmp_buf jumpbuf;
static struct sigaction sa, oldsa;
struct memchunk *chunk_list;
int getpagesize(void);
int get_mem_layout (struct memchunk *chunk_list, int size);

