#ifndef __CLASS_HPP__
#define __CLASS_HPP__
#include <config.h>
#include <ClassMember.hpp>

class Class {
public:
	Class(string _name);
	~Class();
	
	void print();
	
	string getName() const { return name; }
	void addMember(string name);
private:
	string name;
	
	MClassMember members;
};

#endif
