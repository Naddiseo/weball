#ifndef __CONFIG_HPP__
#define __CONFIG_HPP__
/* Handles the config structure in */

#include <config.h>

class Config {
public:
	void addConfig(SPString key, SPString value);
	SPString getValue(SPString key);

private:
	strMap_t configuration;
};

#endif
