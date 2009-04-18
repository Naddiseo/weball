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
	void addAttribute(string name);
	void setAttribute(string name);
private:
	Type* currentType;
	Attribute* currentAttribute;
	Config conf;
	MType types;
};

#endif

