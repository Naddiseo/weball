#ifndef __TYPE_HPP__
#define __TYPE_HPP__
/* 
	Handles the built-in types such as bool, int, string
	Also allows for augmented types.
*/

#include <config.h>

class Type {
public:
	Type(SPString _name);
	void addAttribute(SPAttribute attr);
	SPAttribute getAttribute(SPString key);
	
	SPString getName { return name; }
private:
	SPString name;
	MSPAttribute attributes;
};

#endif

