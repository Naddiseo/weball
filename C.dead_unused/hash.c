#include <hash.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#ifdef NDEBUG
#	define warn(x)   { printf("(%s:%d) warning: %s\n", __FILE__, __LINE__, x); }
#	define die(x, y) { printf("(%s:%d) error: %s\n", __FILE__, __LINE__, x); return y; }
#else
#	define warn(x)   {(void)0; }
#	define die(x, y) { return y; }
#endif


#define derefdata(e) ((void*)*(size_t*)e->data)

void free_entry(t_entry* e);
void free_bucket(t_bucket b);

unsigned int hashit(unsigned int b, char* key, int len) {
	unsigned int ret = 0;
	int i = 0;
	for (i = 0; i < len; i++) {
		ret += (unsigned)key[i];
		ret += (ret << 10);
		ret ^= (ret >> 6);
	}
	ret += (ret << 3);
	ret ^= (ret >> 11);
	ret += (ret << 15);
	ret %= b;
	
	return ret;
	
}

t_hash* new_hash(unsigned int b) {
	t_hash* hash = (t_hash*)malloc(sizeof(t_hash));
	
	if (hash == NULL) {
		die("could not allocate hash", NULL);
	}
	hash->cs = CS;
	
	hash->buckets = (t_bucket*)calloc(b, sizeof(t_bucket));
	
	if (hash->buckets == NULL) {
		die("could not allocate buckets", NULL);
	}
	
	int i = 0;
	for (i = 0; i < b; i++) {
		hash->buckets[i].count = 0;
		hash->buckets[i].head = NULL;
		hash->buckets[i].cs = CS;
	}
	
	hash->count = b;
	return hash;
}

void delete_hash(t_hash* ht) {
	int i = 0;
	for (i = 0; i < ht->count; i++) {
		if (ht->buckets[i].cs == CS) {
			free_bucket(ht->buckets[i]);
			
		}
	}
	free(ht->buckets);
	free(ht);
}

void free_bucket(t_bucket b) {
	if (b.cs != CS) {
		die("Bucket is null",);
	}
	
	if (b.count > 0) {
		// will take care of the others.
		free_entry(b.head);
	}
}


void free_entry(t_entry* e) {
	if (e == NULL || e->cs != CS) {
		warn("e is null/csfail");
		return;
	}
	if (e->next != NULL && e->next != e) {
		//XXX may cause an infinite loop?
		warn("e has a next");
		free_entry(e->next);
	}
	warn("freeing e");
	if (e->dtor != NULL) {
		warn("freeing e->data");
		(*e->dtor)(derefdata(e));
	}
	free(e);
}

int set_data(t_hash* ht, char* key, unsigned int klen, void* data, dtor_t dtor) {

	if (ht == NULL || ht->cs != CS) {
		die("hash table is null", 0);
	}

	t_entry* e = exists(ht, key, klen);
	
	if (e != NULL && e->cs ==CS) {
		if (e->dtor != 0) {
			warn("replacing e->data, so freeing");
			(*e->dtor)(derefdata(e));
		}
		e->data = data;
		e->dtor = dtor;
		return 1;
	}
	
	return 0;

}

void* get_data(t_hash* ht, char* key, unsigned int klen) {

	if (ht == NULL || ht->cs != CS) {
		die("hash table is null", NULL);
	}

	t_entry* t = exists(ht, key, klen);
	
	if (t != NULL && t->cs ==CS) {
		return t->data;
	}
	
	return NULL;

}


t_entry* exists(t_hash* ht, char* key, unsigned int klen) {

	if (ht == NULL || ht->cs != CS) {
		die("hash table is null", NULL);
	}
	
	unsigned int bn = hashit(ht->count, key, klen);
	t_bucket* b = &ht->buckets[bn];
	t_entry* t = b->head;
	
	int i = 0;
	for (i = 0; i < b->count; i++) {
		if (t == NULL) {
			die("t is null?", NULL);
		}
		else if (t->cs != CS) {
			die("An element failed CS", NULL);
		}
		else if (t->kl == klen) {
			if (strncmp(t->key, key, klen) == 0) {
				warn("exists");
				return t;
			}
		}
		t = t->next;
	}
	return NULL;
}

int add_to_bucket(t_bucket* b, t_entry* e) {
	if (b->cs != CS) {
		die("bucket failed CS", -1);
	}
	
	if (b->count == 0) {
		b->head = e;
		b->count++;
		warn("adding first");		
	}
	else {
		t_entry* t = b->head;
		int i = 0;
		for (i = 0; i < b->count; i++) {
			if (t->cs != CS) {
				die("An element failed CS", -1);
			}
			else if (t->kl == e->kl &&  (strncmp(t->key, e->key, e->kl) == 0)) {
				die("already an entry with that key", -1);
			} else {
				if (t->next == NULL) {
					t->next = e;
					b->count++;
					warn("adding");
					break;
				}
			}
			t = t->next;
		}
	}
	
	
	
	return 1;
	
}

int add_new(t_hash* ht, char* key, unsigned int klen, void* data, dtor_t dtor) {
	
	if (ht == NULL || ht->cs != CS) {
		die("hash table is null", -1);
	}

	unsigned int b = hashit(ht->count, key, klen);
	
	t_entry* e = (t_entry*)malloc(sizeof(t_entry));	
	if (e == NULL) {
		die("e is null", -1);
	}
	e->key = key;
	e->kl = klen;
	e->data = data;
	e->next = NULL;
	e->cs = CS;
	e->dtor = dtor;

	add_to_bucket(&ht->buckets[b], e);
	
	

	return 0;
}

