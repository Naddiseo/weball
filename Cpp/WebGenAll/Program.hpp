#ifndef __PROGRAM_HPP__
#define __PROGRAM_HPP__
#include <config.h>
#include <Config.hpp>
#include <Type.hpp>
#include <Attribute.hpp>
#include <TypeValue.hpp>
#include <Class.hpp>
#include <IVal.hpp>

class Program {
public:
	Program();
	~Program();
	void addConfig(string key, string value);
	
	void newType (string name, bool set);
	void setType (string name);
	void copyType(string original, string name);
	
	void addTypeValue(TypeValue* value);
	void addAttribute(string name, bool set);
	void setAttribute(string name);
	
	void newClass(string name, bool set);
	void setClass(string name);
	
	void addClassMember(string type, string name);
	void addPK();
	void addIndex();
	void addIValToClass(IVal*);
	void endPK();
	void endIndex();
	
	void print();
	
	void resolveAllIVals();	
	void resolveIVal(IVal* v);
	
private:
	Type*         currentType;
	Attribute*    currentAttribute;
	Class*        currentClass;
	ClassMember*  currentClassMember;
	Config   conf;
	MType   types;
	MClass  classes;
};

#endif

