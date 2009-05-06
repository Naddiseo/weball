#include <IVal.hpp>

string 
IVal::getResolvedName() const {
	if (className == "" ) {
		return memberName;
	}
	return string(className) + "." + memberName;
}
