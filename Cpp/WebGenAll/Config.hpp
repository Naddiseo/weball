#ifndef __CONFIG_HPP__
#define __CONFIG_HPP__
#include <string>
#include <map>

typedef std::map<std::string, std::string> configMap_t;

void addConfig(std::string key, std::string value);

#endif
