#include <Type.hpp>
#include <error.hpp>

Type::Type(string _name) {
	name = _name;
}

Type::~Type() {
	foreach(PAttribute a, attributes) {
		delete a.second;
	}
}

void 
Type::addAttribute(Attribute* attr) {
	attributes[attr->getName()] = attr;
}

Attribute*
Type::getAttribute(string key) {
	if (attributes.find(key) == attributes.end()) {
		pdie("Attribute does not exist");
	}
	
	return attributes[key];
}

Attribute*
Type::addAttribute(string name) {
	Attribute* ret = new Attribute(name);
	addAttribute(ret);
	return ret;
}

void
Type::copy(Type* original) {
	foreach (PAttribute a, original->attributes) {
		addAttribute(a.second->getName())->copy(a.second);
	}
}
