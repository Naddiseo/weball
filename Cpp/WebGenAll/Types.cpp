#include <Types.hpp>
#include <TypeValue.hpp>

static typesMap_t types;

void types_init() {
	Type* t;
	newType("bool", NULL);
	newType("int", NULL);
	t = newType("uint", NULL);
	TypeValueList_t* v = new TypeValueList_t();
	v->push_back(new TypeValue(0));
	t->addAttribute(std::string("min"), v);
}

void types_dtor() {
	for (typesMap_t::iterator iter = types.begin(); iter != types.end(); iter++) {
		if (iter->second) {
			delete iter->second;
		}
	}
}

void
Type::addAttribute(std::string _name, TypeValueList_t* _value) {
	if (attr->find(_name) == attr->end()) {
		(*attr)[name] = _value;
	}		
}


void
Type::copyAttributes(attributeMap_t* _attr) {
	attributeMap_t::iterator it;
	for (it = _attr->begin(); it != _attr->end(); it++) {}
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
	Type* newT = new Type(name, attrs);
	types[name] = newT;
	return newT;
}

Type* copyType(std::string typeName, std::string newName) {
	Type* t = getType(typeName);
	Type* newT = getType(newName);
	if (!t) {
		//die
	}
	
	if (!newT) {
		newT = new Type(newName);
	}
	
	attributeMap_t* att = t->getAttributes();	
	
	newT->copyAttributes(att);
}

Type* copyType(std::string typeName, Type* newT) {
	Type* t = getType(typeName);
	if (!t or !newT) {
		//die
	}
	
	attributeMap_t* att = t->getAttributes();
	
	newT->copyAttributes(att);
}

Type* addAttributes(std::string typeName, attributeMap_t* attrs);

