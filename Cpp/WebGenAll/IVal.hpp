#ifndef __IVAL_HPP__
#define __IVAL_HPP__
#include <config.h>


class IVal {
public:
	IVal(string _class, string _member) : className(_class), memberName(_member) {}

	string getClassName()    const { return className;    }
	string getMemberName()   const { return memberName;   }
	
	string getResolvedName() const;
	
	Class* getClass()        const { return classp;       }
	ClassMember* getMember() const { return classMemberp; }
	
	void setClass (Class*       _c) { classp       = _c;  }
	void setMember(ClassMember* _m) { classMemberp = _m;  } 
	
private:
	// For looking
	string            className;
	string            memberName;
	
	// The actual pointers
	Class*            classp;
	ClassMember*      classMemberp;
};


#endif
