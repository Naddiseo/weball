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
	void addConfig(string key, string value);
	void newType (string name);
	void setType (string name);
	void copyType(string original, string name);
	
	void addTypeValue(TypeValue* value);
private:
	SPType currentType;
	SPAttribute currentAttribute;
	Config conf;
	MSPType types;
};

#endif

