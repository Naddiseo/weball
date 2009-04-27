#ifndef __CLASS_HPP__
#define __CLASS_HPP__
#include <config.h>
#include <ClassMember.hpp>
#include <IVal.hpp>

typedef std::vector<VIVal*> VVIVal;

class Class {
public:
	Class(string _name);
	~Class();
	
	void print();
	
	string getName() const { return name; }
	ClassMember* addMember(string name);
	
	ClassMember* getMemberByName(string _name) { return members[_name]; }
	
	void addPK();
	void addIndex();
	void addIVal(IVal* iv);
	
	void endPK();
	void endIndex();
	
private:
	string name;
	
	MClassMember members;
	
	VIVal* cmList;
	
	VIVal pk;
	VVIVal indexes;
};

#endif
