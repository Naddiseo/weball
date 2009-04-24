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
}

void
Class::print() {
	std::cout << "Class(" << getName() << ")" << std::endl;
	foreach (PClassMember cm, members) {
		std::cout << "\t Member "; cm.second->print();
	}
}

ClassMember*
Class::addMember(string name) {
	if (members.find(name) != members.end()) {
		pdie("Member " + name + " already exists");
	}
	ClassMember* cm = new ClassMember(name);
	members[name] = cm;
	return cm;
}
