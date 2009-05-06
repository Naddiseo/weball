#ifndef __DBFUNCTION_HPP__
#define __DBFUNCTION_HPP__
#include <config.h>

class DBFunction {
public:
	DBFunction(string _name) : name(_name) {}
	
	void addArg(IVal* arg) { args.push_back(arg); }
	
private:
	string name;
	VIVal  args;
};

#endif
