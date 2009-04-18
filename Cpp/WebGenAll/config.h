#ifndef __CONFIG_H__
#define __CONFIG_H__

#include <iostream>

#include <vector>
#include <map>
#include <string>

#include <boost/shared_ptr.hpp>
#include <boost/foreach.hpp>
#define foreach BOOST_FOREACH

typedef std::string string;
typedef std::map<string, string>           MString;
typedef std::map<string, string>::iterator MString_it;

class Config;
typedef boost::shared_ptr<class Config> SPConfig;

class Type;
typedef boost::shared_ptr<class Type>  SPType;
typedef std::map<string, SPType>      MSPType;

class Attribute;
typedef boost::shared_ptr<class Attribute>  SPAttribute;
typedef std::map<string, SPAttribute>      MSPAttribute;

class TypeValue;
typedef boost::shared_ptr<class TypeValue>  SPTypeValue;
typedef std::vector<SPTypeValue>            VSPTypeValue;

#endif

