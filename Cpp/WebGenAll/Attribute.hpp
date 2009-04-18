#ifndef __ATTRIBUTE_HPP__
#define __ATTRIBUTE_HPP__
#include <config.h>
#include <TypeValue.hpp>

class Attribute {
public:
	Attribute(string _name);
	~Attribute();
	
	void addValue(TypeValue* value);
	
	Attribute* addValue(string        _s);
	Attribute* addValue(unsigned int _ui);
	Attribute* addValue(int           _i);
	Attribute* addValue(bool          _b);
	
	string getName() { return name; }
	
	void copy(Attribute* original);
	
private:
	string name;
	VTypeValue values;
};

#endif
