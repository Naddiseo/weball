#include <Attribute.hpp>
#include <error.hpp>

Attribute::Attribute(string _name) {
	name = _name;
}

Attribute::~Attribute() {
	foreach(TypeValue* v, values) {
		delete v;
	}
}

void 
Attribute::addValue(TypeValue* value) {
	if (!value) {
		pdie("Could not allocate TypeValue");
	}
	values.push_back(value);
}


Attribute*
Attribute::addValue(string        _s) {
	addValue(new TypeValue(_s));
	return this;
}

Attribute* 
Attribute::addValue(unsigned int _ui) {
	addValue(new TypeValue(_ui));
	return this;
}

Attribute*
Attribute::addValue(int           _i) {
	addValue(new TypeValue(_i));
	return this;
}

Attribute*
Attribute::addValue(bool          _b) {
	addValue(new TypeValue(_b));
	return this;
}

