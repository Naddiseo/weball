#include <Attribute.hpp>

Attribute(SPString _name) {
	name = _name;

}

void addValue(SPTypeValue value) {
	values.push_back(value);
}

SPAttribute
newAttribute(std::string name) {
	SPString n(name);
	SPAttribute ret(new Attribute(n));
	
	return ret;
}
