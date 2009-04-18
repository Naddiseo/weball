#ifndef __TYPEVALUE_HPP__
#define __TYPEVALUE_HPP__

#include <config.h>

class TypeValue {
public:
	TypeValue (SPString _s)     : stringval(_s), type(STR) {}
	TypeValue (unsigned int _u) : uintval(_u), type(UINT) {}
	TypeValue (int _i)          : intval(_i), type(INT) {}
	TypeValue (bool _b)         : boolval(_b), type(B) {}
	
	void print();
private:
	SPString stringval;
	union {
		unsigned int uintval;
		int intval;
	};
	bool boolval;
	
	
	enum type_e {
		STR = 1,
		UINT,
		INT,
		B
	};
	type_e type;
};

#endif
