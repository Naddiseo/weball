#include <config.h>

SPString mkstr(const char* s) {
	SPString ret(new std::string(s));
	return ret;
}

SPString mkstr(std::string s) {
	SPString ret(new std::string(s));
	return ret;
}

SPString mkstr(std::string* s) {
	SPString ret(s);
	return ret;
}
