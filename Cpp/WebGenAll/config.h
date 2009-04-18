#ifndef __CONFIG_H__
#define __CONFIG_H__

#include <iostream>

#include <vector>
#include <map>
#include <string>

#include <boost/shared_ptr.hpp>
#include <boost/foreach.hpp>
#define foreach BOOST_FOREACH

typedef boost::shared_ptr<std::string>          SPString;
typedef std::map<SPString, SPString>           MSPString;
typedef std::map<SPString, SPString>::iterator MSPString_it;

SPString mkstr(const char* s);
SPString mkstr(std::string s);
SPString mkstr(std::string* s);

class Config;
typedef boost::shared_ptr<class Config> SPConfig;

class Type;
typedef boost::shared_ptr<class Type>  SPType;
typedef std::map<SPString, SPType>     MSPType;

class Attribute;
typedef boost::shared_ptr<class Attribute>  SPAttribute;
typedef std::map<SPString, SPAttribute>     MSPAttribute;

class TypeValue;
typedef boost::shared_ptr<class TypeValue>  SPTypeValue;
typedef std::vector<SPTypeValue>            VSPTypeValue;

#endif

