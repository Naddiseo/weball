#ifndef __CLASS_HPP__
#define __CLASS_HPP__
#include <map>
#include <string>
#include <vector>
#include <iostream>
#include <TypeValue.hpp>
#include <Types.hpp>

typedef std::vector<std::string> keylist_t;
typedef std::vector<keylist_t*> indexes_t; 


class Class {
public:
	Class(std::string _n) : name(_n) {}
	
	~Class();
	
	std::string getName() const { return name; }
	
	void print();
	
	void addPK(keylist_t*);
	void addIndex(keylist_t*);
	
private:
	std::string name;
	
	keylist_t* pkey;
	indexes_t indexes;
};

typedef std::map<std::string, class Class*> classMap_t;

Class* newClass(std::string name);


void classes_dtor();
void classes_print();
#endif

