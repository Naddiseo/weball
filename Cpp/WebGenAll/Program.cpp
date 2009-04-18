#include <Program.hpp>
#include <error.hpp>

Program::Program() {

	types["bool"  ] = new Type("bool"  );
	types["int"   ] = new Type("int"   );
	types["uint"  ] = new Type("uint"  );
	types["string"] = new Type("string");

	types["bool"  ]
		->addAttribute("range")
			->addValue(0)
			->addValue(1);
	
	types["uint"]
		->addAttribute("min")
			->addValue(0);
}



void 
Program::addConfig(string key, string value) {
	conf.addConfig(key, value);
}

void 
Program::setType(string name) {
	if (types.find(name) == types.end()) {
		pdie("Type does not exist");
	}
	currentType = types[name];
}

void 
Program::copyType(string original, string name) {
	if (types.find(original) == types.end()) {
		pdie(string("No type of that name found (") + original + ")" );
	}
	
	Type* ori  = types[original];
	Type* diff = types[name];
	diff->copy(ori);
}

void 
Program::newType (string name) {
	if (types.find(name) != types.end()) {
		pdie("That type exists already");
	}
	
	Type* newT = new Type(name);
	if (!newT) {
		pdie("Could not allocate Type" + name);
	}
	types[name] = newT;
}

void 
Program::addTypeValue(TypeValue* value) {
	currentAttribute->addValue(value);
}

void 
Program::addAttribute(string name) {
	if (!currentType) {
		pdie("Cannot set attribute on null type");
	}
	currentType->addAttribute(new Attribute(name));
}

void 
Program::setAttribute(string name) {
	if (!currentType) {
		pdie("Current type not set..");
	}
	currentAttribute = currentType->getAttribute(name);
}

void
Program::print() {
	foreach (PType t, types) {
		t.second->print();
	}
}
