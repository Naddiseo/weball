#include <stdlib.h>
#include <stdio.h>
#include <hash.h>
#include <string.h>

void char_dtor(void* p) {
	free(p);
}

void hash_dtor(void* p) {
	delete_hash((t_hash*)p);
}

int main() {
	
	int data = 5;
	int data2 = 2;
	char* foo = "HI THERE";
	
	char* a = (char*)malloc(sizeof(char) * 100);
	memset(a, 65, 100);
	a[100] = 0;
	
	char* b = (char*)malloc(sizeof(char) * 100);
	memset(b, 66, 100);
	a[100] = 0;
	
	t_hash* h = new_hash(2);
	t_hash* h2 = new_hash(2);
	if (h == NULL) {
		fprintf(stderr, "Couldn't allocate hash\n");
		return 0;
	}
	if (h2 == NULL) {
		fprintf(stderr, "Couldn't allocate hash\n");
		return 0;
	}
	add_new(h, "basdf", 5, &data, NULL);
	add_new(h, "8", 1, &data2, NULL);
	add_new(h, "c", 1, &foo, NULL);
	add_new(h, "str", 3, &a, &char_dtor);
	
	add_new(h, "hash", 4, &h2, &hash_dtor);

	if (exists(h, "basdf", 1)) { 
		int* dataret = (int*)get_data(h, "basdf", 5);
		printf("basdf exists: it is %d\n", *dataret); 
	} else { puts("basdf not exist"); }
	
	if (exists(h, "c", 1)) { 
		char** dataret = (char**)get_data(h, "c", 1);
		printf("c exists: it is %s\n", *dataret); 
	} else { puts("c not exist"); }
	
	if (exists(h, "str", 3)) { 
		char** dataret = (char**)get_data(h, "str", 3);
		printf("str exists: it is %s\n", *dataret); 
	} else { puts("str not exist"); }
	
	set_data(h, "str", 3, &b, &char_dtor);
	
	if (exists(h, "str", 3)) { 
		char** dataret = (char**)get_data(h, "str", 3);
		printf("str exists: it is %s\n", *dataret); 
	} else { puts("str not exist"); }
	
	if (exists(h, "hash", 4)) { 
		puts("hash exists"); 
	} else { puts("hash not exist"); }
	
	if (exists(h, "r", 1)) { puts("r exists"); } else { puts("r not exist"); }
	delete_hash(h);
	
	
	
	
	return 0;

}
