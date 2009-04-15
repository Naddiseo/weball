#include <Class.hpp>
#include <cstdlib> // for exit

static classMap_t classes;


extern "C" void yyerror (char const * str);

Class::~Class() {

	if (pkey) {
		delete pkey;
	}
	
	for (indexes_t::iterator it = indexes.begin(); it != indexes.end(); it++) {
		if (*it) {
			delete *it;
		}
	}
}

void 
Class::addPK(keylist_t* pk) {
	if (pkey) {
		yyerror("Primary key given twice.");
		exit(-1);
	}
	
	pkey = pk;
}

void 
Class::addIndex(keylist_t* i) {
	if (!i) {
		yyerror("Given empty index list");
		exit(-1);
	}
	indexes.push_back(i);
}

Class* newClass(std::string name) {
	if(classes.find(name) != classes.end()) {
		yyerror("Class already exists");
		exit(-1);
	}
	
	Class* newC = new Class(name);
	
	classes[name] = newC;
	
	return newC;
}

void classes_dtor() {
	for (classMap_t::iterator it = classes.begin(); it != classes.end(); it++) {
		if (it->second) {
			delete it->second;
		}
	}
}

void classes_print() {
	for (classMap_t::iterator it = classes.begin(); it != classes.end(); it++) {
		if (it->second) {
			it->second->print();
		}
	}
}

void 
Class::print() { 
	std::cout << "Class " << name << std::endl;
	std::cout << "\tPK(";
	if (pkey) {
		for (keylist_t::iterator it = pkey->begin(); it != pkey->end(); it++) {
			std::cout << *it << ",";
		}
	}
	std::cout << ")" << std::endl;
	for (indexes_t::iterator idx_it = indexes.begin(); idx_it != indexes.end(); idx_it++) {
		if (keylist_t* i = *idx_it) {
			std::cout << "\tINDEX(";
			for (keylist_t::iterator it = i->begin(); it != i->end(); it++) {
				std::cout << *it << ",";
			}
			std::cout << ")" << std::endl;
		}
	}
}
