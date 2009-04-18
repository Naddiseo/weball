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
	void newType (SPString name);
	void setType (SPString name);
	void copyType(SPString original, SPString name);
	
	void addTypeValue(TypeValue* value);
private:
	SPType currentType;
	SPAttribute currentAttribute;
	Config conf;
	MSPType types;
};

#endif

