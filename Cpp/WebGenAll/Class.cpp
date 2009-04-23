#include <Class.hpp>

#include <iostream>

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
}

void
Class::addMember(string name) {
	members[name] = new ClassMember(name);
}
