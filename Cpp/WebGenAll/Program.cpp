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

Program::~Program() {
	foreach (PType t, types) {
		delete t.second;
	}
	
	foreach (PClass c, classes) {
		delete c.second;
	}
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
Program::newType (string name, bool set = false) {
	if (types.find(name) != types.end()) {
		pdie("That type exists already");
	}
	
	Type* newT = new Type(name);
	if (!newT) {
		pdie("Could not allocate Type " + name);
	}
	types[name] = newT;
	
	if (set) {
		currentType = newT;
	}
}

void 
Program::addTypeValue(TypeValue* value) {
	currentAttribute->addValue(value);
}

void 
Program::addAttribute(string name, bool set = false) {
	if (!currentType) {
		pdie("Cannot set attribute on null type");
	}
	Attribute* newAttr = new Attribute(name);
	if (!newAttr) {
		pdie("Could not allocate enough memory for Attribute");
	}
	currentType->addAttribute(newAttr);
	
	if (set) {
		currentAttribute = newAttr;
	}
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
		std::cout << "Type " << t.second->getName() << std::endl;
		t.second->print(1);
	}
	
	foreach (PClass c, classes) {
		c.second->print(0);
	}
}


void 
Program::newClass(string name, bool set = false) {
	if (classes.find(name) != classes.end()) {
		pdie("That class exists already");
	}
	
	Class* newC = new Class(name);
	if (!newC) {
		pdie("Could not allocate Class " + name);
	}
	classes[name] = newC;
	
	if (set) {
		currentClass = newC;
	}
}

void 
Program::setClass(string name) {
	if (classes.find(name) == classes.end()) {
		pdie("Class does not exist");
	}
	currentClass = classes[name];
}

void
Program::addClassMember(string type, string name) {
	Type* basetype = types[type];
	if (!basetype) {
		pdie("Type " + type + " does not exist");
	}
	
	currentType = currentClass->addMember(name, basetype);
}

void 
Program::addPK() {
	currentClass->addPK();
}

void
Program::addIndex() {
	currentClass->addIndex();
}

void
Program::addIValToClass(IVal* v) {	
	currentClass->addIVal(v);
}

void 
Program::endPK() {
	currentClass->endPK();
}

void 
Program::endIndex() {
	currentClass->endIndex();
}

void
Program::resolveAllIVals() {}

void
Program::resolveIVal(IVal* v) {
	// resolve what the IVal is pointing to
	
	string _class  = v->getClassName();
	string _member = v->getMemberName();
	
	Class*       c  = NULL;
	ClassMember* cm = NULL;
	
	
	if (_class == "" and !currentClass) {
		pdie("No class set");
	}
	else if (_class != "") {
		c = classes[_class];
	}
	else {
		c = currentClass;
	}
	
	v->setClass(c);
	
	if (_member == "") {
		pdie("Class pointers not supported yet");
	}
	
	cm = c->getMemberByName(_member);
	
	if (!cm) {
		pdie("Class member (" + _member + ") not found");
	}
	
	v->setMember(cm);	
	
}
