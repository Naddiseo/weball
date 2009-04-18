#include <Program.hpp>
#include <error.hpp>

Program::Program() {
	
	//SPString boolAttrName("range");
	SPAttribute boolAttr = Attribute::newAttribute(std::string("range"));//(new Attribute(boolAttrName));
	
	SPTypeValue min(new TypeValue(0));
	SPTypeValue max(new TypeValue(1));
	
	boolAttr->addValue(min);
	boolAttr->addValue(max);
	
	SPString boolName = mkstr("bool");
	SPType boolType(new Type(boolName));
	
	types[boolName] = boolType;
}

void 
Program::addConfig(SPString key, SPString value) {
	conf.addConfig(key,value);
}

void 
Program::setType(SPString name) {
	if (types.find(name) != types.end()) {
		pdie("Type already exists");
	}
	currentType = types[name];
}

void 
Program::copyType(SPString original, SPString name) {
	if (types.find(original) == types.end()) {
		pdie("No type of that name found");
	}
	
	SPType ori  = types[original];
	SPType diff = types[name];
}

void 
Program::newType (SPString name) {
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
