#ifndef __CLASS_HPP__
#define __CLASS_HPP__
#include <config.h>
#include <ClassMember.hpp>

typedef std::vector<VClassMember> VVClassMember;

class Class {
public:
	Class(string _name);
	~Class();
	
	void print();
	
	string getName() const { return name; }
	ClassMember* addMember(string name);
	
	
	
private:
	string name;
	
	MClassMember members;
	
	VClassMember pk;
	VVClassMember indexes;
};

#endif
