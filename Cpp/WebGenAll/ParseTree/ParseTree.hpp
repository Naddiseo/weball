#ifndef __PARSETREE_HPP__
#define __PARSETREE_HPP__
#include <config.h>

class ParseTree {
public:
	typedef ParseTree* PTree;
	
	virtual
	~ParseTree() {}
	
	virtual void
	delete_r() = 0;
	
#ifdef NDEBUG
	void
	ps(unsigned n) const
		{ while(n--) { std::cout<<' '; } }

	/* If only typeid.name gave you something useful... */
	virtual const char *
	name() const = 0;

	virtual void
	print(unsigned) = 0;
#endif
};

template<unsigned char N>
class NaryNode: public ParseTree {
protected:

	PTree *pt_;

public:

	NaryNode();
	~NaryNode();

	void
	delete_r();

#ifdef NDEBUG
	virtual const char *
	name() const = 0;

	void
	print(unsigned n) {
		ps(n);
		std::cout<<name()<<'\n';
		n += 3;
		for(unsigned char i = 0; i < N; i++) {
			if(pt_[i]) pt_[i]->print(n);
			else {
				ps(n);
				std::cout<<"null node\n";
			}
		}
	};
#endif

};

class VarNode: public ParseTree {

	typedef std::vector<PTree> PTList;

	PTList pt_;

public:

	VarNode(PTree);

	/* Default destructor is good */

	void
	delete_r();

	inline VarNode*
	push(PTree _pt)
		{ pt_.push_back(_pt); return this; }

#ifdef NDEBUG
	const char *
	name() const
		{ return "VarNode"; }

	void
	print(unsigned n) {
		ps(n);
		std::cout<<name()<<'\n';
		n += 3;
		PTList::iterator i;
		for(i = pt_.begin(); i < pt_.end(); i++) {
			if(*i) (*i)->print(n);
		}
	};
#endif

};

#endif
