#include <Program.hpp>

Program::Program() {
	
	//SPString boolAttrName("range");
	SPAttribute boolAttr = Attribute::newAttribute("range");//(new Attribute(boolAttrName));
	
	SPTypeValue min(0);
	SPTypeValue max(1);
	
	boolAttr->addValue(min);
	boolAttr->addValue(max);
	
	SPString boolName("bool");
	SPType boolType(new Type(boolName));
	
	types->addType(boolType);
}

void 
Program::addConfig(SPString key, SPString value) {
	conf.addConfig(key,value);
}
