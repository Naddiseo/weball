#ifndef __weball_fn_h__
#define __weball_fn_h__

int init_weball_fn();
int deinit_weball_fn();

int new_class(char* name);
#define CLASS(n) new_class(n)

#endif

