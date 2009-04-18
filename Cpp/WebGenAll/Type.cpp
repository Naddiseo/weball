#include <Type.hpp>
#include <error.hpp>

Type::Type(string _name) {
	name = _name;
}

void 
Type::addAttribute(SPAttribute attr) {
	attributes[attr->getName()] = attr;
}

SPAttribute 
Type::getAttribute(string key) {
	if (attributes.find(key) == attributes.end()) {
		pdie("Attribute does not exist");
	}
	
	return attributes[key];
}
