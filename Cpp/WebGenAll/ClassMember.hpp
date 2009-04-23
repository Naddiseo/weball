#ifndef __CLASSMEMBER_HPP__
#define __CLASSMEMBER_HPP__
#include <config.h>
#include <Type.hpp>

class ClassMember : public Type {
public:
	ClassMember(string name) : Type(name) {}
	~ClassMember() {}
private:
};

#endif
