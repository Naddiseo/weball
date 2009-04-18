#include <Program.hpp>
#include <error.hpp>

Program::Program() {
	
	string boolAttrName("range");
	SPAttribute boolAttr = Attribute::newAttribute(boolAttrName);//(new Attribute(boolAttrName));
	
	SPTypeValue min(new TypeValue(0));
	SPTypeValue max(new TypeValue(1));
	
	boolAttr->addValue(min);
	boolAttr->addValue(max);
	
	string boolName = "bool";
	SPType boolType(new Type(boolName));
	
	types[boolName] = boolType;
}

void 
Program::addConfig(string key, string value) {
	conf.addConfig(key, value);
}

void 
Program::setType(string name) {
	if (types.find(name) != types.end()) {
		pdie("Type already exists");
	}
	currentType = types[name];
}

void 
Program::copyType(string original, string name) {
	if (types.find(original) == types.end()) {
		pdie("No type of that name found");
	}
	
	SPType ori  = types[original];
	SPType diff = types[name];
}

void 
Program::newType (string name) {
	if (types.find(name) != types.end()) {
		pdie("That type exists already");
	}
	
	SPType newT(new Type(name));
	types[name] = newT;
}

void 
Program::addTypeValue(TypeValue* value) {
	SPTypeValue tv(value);
	
	currentAttribute->addValue(tv);
}
