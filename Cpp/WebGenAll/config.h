#ifndef __CONFIG_H__
#define __CONFIG_H__

#include <iostream>

#include <vector>
#include <map>
#include <string>

#include <boost/shared_ptr.hpp>
#include <boost/foreach.hpp>
#define foreach BOOST_FOREACH

typedef boost::shared_ptr<std::string> SPString;
typedef std::map<SPString, SPString> strMap_t;
typedef std::map<SPString, SPString>::iterator strMapIt_t;

class Config;
typedef boost::shared_ptr<class Config*> SPConfig;

static std::string baseDirectory;

#endif

