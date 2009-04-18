#include <TypeValue.hpp>

#include <iostream>
#include <error.hpp>

void 
TypeValue::print() {
	switch (type) {
		case STR:
			std::cout << stringval;
			break;
		case INT:
			std::cout << intval;
			break;
		case UINT:
			std::cout << uintval;
			break;
		case B:
			std::cout << boolval;
			break;
		default:
			std::cout << "NOVAL";
	}
}

TypeValue* 
TypeValue::copy() {
	TypeValue* ret;
	switch (type) {
		case STR:
			ret = new TypeValue(stringval);
			break;
		case INT:
			ret = new TypeValue(intval);
			break;
		case UINT:
			ret = new TypeValue(uintval);
			break;
		case B:
			ret = new TypeValue(boolval);
			break;
		default:
			pdie("Something has gone terribly wrong");
	}
	
	if (!ret) {
		pdie("Could not allocate TypeValue");
	}
	return ret;
}
