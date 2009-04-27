#ifndef __CONFIG_H__
#define __CONFIG_H__

#include <iostream>

#include <vector>
#include <map>
#include <string>

#include <boost/foreach.hpp>
#define foreach BOOST_FOREACH

typedef std::string                      string;
typedef string*                         PString;
typedef std::vector<PString>           VPString;
typedef std::map<string, string>        MString;

class Type;
typedef std::map <string, Type*>        MType;
typedef std::pair<string, Type*>        PType;

class Attribute;
typedef std::map <string, Attribute*>   MAttribute;
typedef std::pair<string, Attribute*>   PAttribute;

class TypeValue;
typedef std::vector<TypeValue*>         VTypeValue;

class Class;
typedef std::map <string, Class*>       MClass;
typedef std::pair<string, Class*>       PClass;

class ClassMember;
typedef std::map <string, ClassMember*> MClassMember;
typedef std::pair<string, ClassMember*> PClassMember;
typedef std::vector<ClassMember*>       VClassMember;

class IVal;
typedef std::vector<IVal*>              VIVal;

PString addString(PString);
void    killStrings();

#endif

