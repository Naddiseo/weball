#ifndef __CONFIG_H__
#define __CONFIG_H__

#include <iostream>

#include <vector>
#include <map>
#include <string>

#include <boost/foreach.hpp>
#define foreach BOOST_FOREACH

typedef std::string string;
typedef std::map<string, string>           MString;
typedef std::map<string, string>::iterator MString_it;

class Type;
typedef std::map<string, Type*>      MType;
typedef std::pair<string, Type*>     PType;

class Attribute;
typedef std::map<string, Attribute*>  MAttribute;
typedef std::pair<string, Attribute*> PAttribute;

class TypeValue;
typedef std::vector<TypeValue*> VTypeValue;

#endif

