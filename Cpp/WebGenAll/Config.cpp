#include <Config.hpp>

void 
Config::addConfig(SPString key, SPString value) {
	configuration[key] = value;
#ifdef NDEBUG
	std::cerr << "Adding config[" << *key << "] = '" << *value << "'" << std::endl;
#endif
}

SPString 
Config::getValue(SPString key) {
	return configuration[key];
}
