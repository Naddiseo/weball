#ifndef __ATTRIBUTE_HPP__
#define __ATTRIBUTE_HPP__
#include <config.h>

class Attribute {
public:
	Attribute(string _name);
	void addValue(SPTypeValue value);
	
	string getName() { return name; }
	
	static SPAttribute
	newAttribute(string name);
private:
	string name;
	VSPTypeValue values;
};

#endif 
