#include <Attribute.hpp>
#include <error.hpp>

Attribute::Attribute(string _name) {
	name = _name;

}

void 
Attribute::addValue(SPTypeValue value) {
	values.push_back(value);
}

SPAttribute
Attribute::newAttribute(string name) {

	SPAttribute ret(new Attribute(name));
	
	return ret;
}
