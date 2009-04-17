#include <TypeValue.hpp>

#include <iostream>

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
