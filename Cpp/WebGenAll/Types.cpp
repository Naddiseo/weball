#include <Types.hpp>
#include <TypeValue.hpp>

#include <iostream>
#include <cstdlib>

extern "C" void yyerror (char const * str);

static typesMap_t types;

void types_init() {
	Type* t;
	TypeValueList_t* v;
	
	
	
	t = newType(std::string("bool"), NULL);
	v = new TypeValueList_t();
	v->push_back(new TypeValue(0));
	t->addAttribute(std::string("min"), v);
	
	v = new TypeValueList_t();
	v->push_back(new TypeValue(1));
	t->addAttribute(std::string("max"), v);
	
	
	
	newType(std::string("int"), NULL);
	
	
	t = newType(std::string("uint"), NULL);
	v = new TypeValueList_t();
	v->push_back(new TypeValue(0));
	t->addAttribute(std::string("min"), v);
	
	newType(std::string("string"), NULL);
}

void types_dtor() {
	for (typesMap_t::iterator iter = types.begin(); iter != types.end(); iter++) {
		if (iter->second) {
			delete iter->second;
		}
	}
}

void types_print() {
	for (typesMap_t::iterator iter = types.begin(); iter != types.end(); iter++) {
		if (iter->second) {
			iter->second->print();
		}
	}
}

void
Type::print() {
	std::cout << "Type(" << name << ")\n";
	for (attributeMap_t::iterator iter = attr->begin(); iter != attr->end(); iter++) {
		std::cout << "\tAttr(" << iter->first << ")\n";
		for (TypeValueList_t::iterator iter2 = iter->second->begin(); iter2 != iter->second->end(); iter2++) {
			std::cout << "\t\t"; (*iter2)->print(); std::cout << "\n";
		}
	}
}

void
Type::addAttribute(std::string _name, TypeValueList_t* _value) {
	if (attr->find(_name) == attr->end()) {
		(*attr)[_name] = _value;
	}		
}


void
Type::copyAttributes(attributeMap_t* _attr) {
	attributeMap_t::iterator it;
	for (it = _attr->begin(); it != _attr->end(); it++) {
		(*attr)[it->first] = it->second;
	}
}

Type* getType(std::string name) {
	typesMap_t::iterator it;
	
	it = types.find(name);
	if (it != types.end()) {
		return it->second;
	}
	return NULL;
}

Type* newType(std::string name, attributeMap_t* attrs) {
	if (attrs == NULL) {
		attrs = new attributeMap_t();
	}
	Type* newT = new Type(name, attrs);
	types[name] = newT;
	return newT;
}

Type* copyType(std::string typeName, std::string newName) {
	Type* t = getType(typeName);
	Type* newT = getType(newName);
	if (!t) {
		//die
		yyerror("No t");
		exit(-1);
	}
	
	if (!newT) {
		newT = new Type(newName);
		types[newName] = newT;
	}
	
	
	std::cout << "Copying " << typeName << " into " << newName << std::endl;
	
	attributeMap_t* att = t->getAttributes();
	
	newT->copyAttributes(att);
	
	return newT;
}

Type* copyType(std::string typeName, Type* newT) {
	Type* t = getType(typeName);
	std::string error;
	if (!t) {
		error = "No type of name " + typeName;
		yyerror (error.c_str());
		exit(-1);
	}
	if (!newT) {
		yyerror("No newT");
		exit(-1);
	}
	
	attributeMap_t* att = t->getAttributes();
	
	newT->copyAttributes(att);
	return newT;
}

Type* addAttributes(std::string typeName, attributeMap_t* attrs);

