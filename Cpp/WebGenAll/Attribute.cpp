#include <Attribute.hpp>
#include <error.hpp>

Attribute::Attribute(SPString _name) {
	name = _name;

}

void 
Attribute::addValue(SPTypeValue value) {
	values.push_back(value);
}

SPAttribute
newAttribute(std::string name) {

	SPAttribute ret(new Attribute(mkstr(name)));
	
	return ret;
}
