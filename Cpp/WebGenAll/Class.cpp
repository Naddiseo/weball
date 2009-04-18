#include <Class.hpp>

Class::Class(string _name) {
	name = _name
}

Class::~Class() {
	foreach (PClassMember cm, members) {
		delete cm.second;
	}
}
