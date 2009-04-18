#ifndef __TYPE_HPP__
#define __TYPE_HPP__
/* 
	Handles the built-in types such as bool, int, string
	Also allows for augmented types.
*/

#include <config.h>
#include <Attribute.hpp>

class Type {
public:
	Type(string _name);
	~Type();
	
	void addAttribute(Attribute* attr);
	Attribute* addAttribute(string name);
	Attribute* getAttribute(string key);
	
	string getName() { return name; }
private:
	string name;
	MAttribute attributes;
};

#endif

