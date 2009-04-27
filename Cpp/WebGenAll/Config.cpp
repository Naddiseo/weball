#include <Config.hpp>

void 
Config::addConfig(string key, string value) {
	configuration[key] = value;
#ifdef NDEBUG
	std::cerr << "Adding config[" << key << "] = '" << value << "'" << std::endl;
#endif
}

string 
Config::getValue(string key) {
	return configuration[key];
}


