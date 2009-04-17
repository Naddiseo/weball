#include <Config.hpp>
#ifdef NDEBUG
#include <iostream>
#endif

static configMap_t config;

void addConfig(std::string key, std::string value) {
	config[key] = value;
#ifdef NDEBUG
	//std::cout << "Adding config: '" << key << "' = '" << value << "'" << std::endl;
#endif
}
