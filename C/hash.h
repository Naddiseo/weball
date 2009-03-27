#ifndef __hash_h__
#define __haah_h__

typedef void (*dtor_t)(void*);

typedef struct t_entry {
	char* key;
	unsigned int kl;
	void* data;
	struct t_entry* next;
	unsigned int cs;
	dtor_t dtor;
} t_entry;

typedef struct t_bucket {
	t_entry* head;
	int count;
	unsigned int cs;
} t_bucket;

typedef struct {
	int count;
	t_bucket* buckets;
	unsigned int cs;
} t_hash;

t_hash* new_hash(unsigned int b);
void delete_hash(t_hash*);

void* get_data(t_hash*, char* key, unsigned int klen);
int set_data(t_hash*, char* key, unsigned int klen, void* data, dtor_t dtor);
t_entry* exists(t_hash*, char* key, unsigned int klen);
int add_new(t_hash* ht, char* key, unsigned int klen, void* data, dtor_t dtor);

unsigned int hashit(unsigned int b, char* key, int len);

#define CS 0xdeadbeef

#endif
