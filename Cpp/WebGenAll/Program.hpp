#ifndef __PROGRAM_HPP__
#define __PROGRAM_HPP__
#include <config.h>
#include <Config.hpp>
#include <Type.hpp>
#include <Attribute.hpp>
#include <TypeValue.hpp>

class Program {
public:
	Program();
	void addConfig(SPString key, SPString value);
	void newType(std::string name);
private:
	Config conf;
	MSPType types;
};

#endif

