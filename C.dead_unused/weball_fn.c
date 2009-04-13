#include <weball_fn.h>
#include <hash.h>
#include <assert.h>
#include <stddef.h>
#include <string.h>
#include <stdlib.h>

static t_hash* classes;

typedef enum {
	INT = 1,
	UINT,
	STRING,
	CUSTOM
} class_type ;

typedef struct {
	char* name;
	int min;
	int max;
	char* rx;
	class_type type;
} class_entry_t;

typedef struct {
	char* name;
	t_hash* entries;
} class_t;

void class_t_dtor(void* p) {
	if (p != NULL) {
		t_hash* e = ((class_t*)p)->entries;
		if (e != NULL) {
			delete_hash(e);
		}
	}
}

int init_weball_fn() {
	classes = new_hash(1024);
	if (classes == NULL) {
		return 0;
	}
	
	return 1;
}

int deinit_weball_fn() {
	delete_hash(classes);
	
	return 1;
}

int new_class(char* name) {
	// assumes classes has been initialized
	int l = strlen(name);
	if (exists(classes, name, l)) {
		return 0;
	}
	
	class_t* class = (class_t*)malloc(sizeof(class_t));
	class->name = name;
	class->entries = new_hash(1024);
	if (class->entries == NULL) {
		return 0;
	}
	
	add_new(classes, name, l, class, &class_t_dtor);
	
	return 1;
	
}
