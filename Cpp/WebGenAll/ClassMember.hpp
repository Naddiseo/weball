#ifndef __CLASSMEMBER_HPP__
#define __CLASSMEMBER_HPP__
#include <config.h>
#include <Type.hpp>

class ClassMember : public Type {
public:
	ClassMember(string _name, Type* _basetype) : Type(_name) { copy(_basetype); }
	~ClassMember() {}
	
	
	//void print(unsigned int);
private:
	string name;
};

#endif
