#include <defs.hpp>
#include <iostream>
Troles Roles;

void addRole(int id, std::string* name) {
	if (Roles.find(id) != Roles.end()) {
		Roles[id] = name;
		std::cerr << "Found " << id << ": " << name << std::endl;
	}
}

void removeRole(int id) {
	if (Roles.find(id) != Roles.end()) {
		Roles.erase(id);
	}
}
void removeRoles() {
	for (Troles_it it = Roles.begin(); it != Roles.end(); it++) {
		removeRole(it->first);
		delete it->second;
	}
}
