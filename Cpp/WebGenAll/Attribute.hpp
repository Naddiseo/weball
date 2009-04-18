#ifndef __ATTRIBUTE_HPP__
#define __ATTRIBUTE_HPP__
#include <config.h>

class Attribute {
public:
	Attribute(SPString _name);
	void addValue(SPTypeValue value);
	
	SPString getName() { return name; }
	
	static SPAttribute
	newAttribute(std::string name);
private:
	SPString name;
	VSPTypeValue values;
};

#endif 
