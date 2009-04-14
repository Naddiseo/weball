#ifndef __TYPES_HPP__
#define __TYPES_HPP__
#include <map>
#include <string>
#include <Attributes.hpp>
#include <TypeValue.hpp>


class Type {
public:
	Type (std::string _name) : name(_name), attr(new attributeMap_t()) {}
	Type (std::string _name, attributeMap_t* _attr) : name(_name), attr(_attr) { }
	
	std::string 
	getName() const { return name; }
	
	TypeValueList_t*
	getAttribute(std::string attrName) { return (*attr)[attrName]; }
	
	void
	addAttribute(std::string name, TypeValueList_t* value);
	
	attributeMap_t*
	getAttributes() const { return attr; }
	
	void
	copyAttributes(attributeMap_t* _attr);
	
	void print();
private:
	std::string name;
	attributeMap_t* attr;
};

typedef std::map <std::string, Type*> typesMap_t;

Type* getType(std::string name);
Type* newType(std::string name, attributeMap_t* attrs);
Type* copyType(std::string typeName, std::string newName);
Type* copyType(std::string typeName, Type* newT);
Type* addAttributes(std::string typeName, attributeMap_t* attrs);

void types_init();
void types_dtor();

void types_print();

#endif
