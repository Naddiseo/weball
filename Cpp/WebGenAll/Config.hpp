#ifndef __CONFIG_HPP__
#define __CONFIG_HPP__
/* Handles the config structure in */

#include <config.h>

class Config {
public:
	void addConfig(string key, string value);
	string getValue(string key);

private:
	MString configuration;
};

#endif
