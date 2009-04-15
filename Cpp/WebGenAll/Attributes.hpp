#ifndef __ATTRIBUTES_HPP__
#define __ATTRIBUTES_HPP__
#include <map>
#include <vector>
#include <string>
#include <TypeValue.hpp>

typedef std::map<std::string, TypeValueList_t*> attributeMap_t;

/*
 :foo(a,b,c)
 
 attrMap_T[foo] = vector(a,b,c);
*/

//attributeMap_t addAttrValue(attributeMap_t a, std::string v);


#endif

