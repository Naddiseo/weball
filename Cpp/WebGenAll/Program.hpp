#ifndef __PROGRAM_HPP__
#define __PROGRAM_HPP__
#include <config.h>
#include <Config.hpp>
class Program {
public:
	void addConfig(SPString key, SPString value);
private:
	Config conf;
};

#endif

