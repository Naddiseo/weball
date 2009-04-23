#include <config.h>

VPString strings_ptr;

PString addString(PString ret) {
	strings_ptr.push_back(ret);
	return ret;
}

void    killStrings() {
	foreach (PString s, strings_ptr) {
		if (s) {
			delete s;
		}
	}
}
