#ifndef DEFS_HPP_INCLUDED
#define DEFS_HPP_INCLUDED

#include <map>
#include <string>

typedef std::map<int, std::string*> Troles;
typedef std::map<int, std::string*>::iterator Troles_it;



void addRole(int id, std::string* name);
void removeRole(int id);
void removeRoles();

#endif // DEFS_HPP_INCLUDED
