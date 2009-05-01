#include <Class.hpp>

#include <iostream>

#include <error.hpp>

Class::Class(string _name) {
	name = _name;
}

Class::~Class() {
	foreach (PClassMember cm, members) {
		delete cm.second;
	}
	
	foreach (VIVal* index, indexes) {
		foreach (IVal* value, *index) {
			delete value;
		}
		delete index;
	}
}

void
Class::print(unsigned int i = 0) {
	std::cout << getIndent(i) << "Class(" << getName() << ")" << std::endl;
	foreach (PClassMember cm, members) {
		std::cout << getIndent(i + 1) << "Member " << cm.second->getName() << std::endl;
		cm.second->print(i + 2);
	}
	
	std::cout << getIndent(i + 1) << "PK (";
	foreach (IVal* iv, pk) {
		std::cout << iv->getResolvedName() << ",";
	}
	std::cout << ")" << std::endl;
	
	foreach (VIVal* index, indexes) {
		std::cout << getIndent(i + 1) << "INDEX (";
		foreach (IVal* value, *index) {
			std::cout << value->getResolvedName() << ",";
		}
		std::cout << ")" << std::endl;
	}
}

ClassMember*
Class::addMember(string name, Type* _basetype) {
	if (members.find(name) != members.end()) {
		pdie("Member " + name + " already exists");
	}
	ClassMember* cm = new ClassMember(name,  _basetype);
	members[name] = cm;
	return cm;
}


void 
Class::addPK() {
	if (pk.size()) {
		pdie("A primary key already exists on class");
	}
	cmList = &pk;
}

void Class::addIVal(IVal* iv) {
	if (!iv) {
		pdie("Shouldn't get here");
	}
	
	cmList->push_back(iv);
}

void 
Class::addIndex() {
	cmList = new VIVal();
	indexes.push_back(cmList);
}

void 
Class::endPK() {
	endIndex();
}

void 
Class::endIndex() {
	cmList = NULL;
}


