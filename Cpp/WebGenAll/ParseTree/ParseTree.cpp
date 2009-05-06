#include <ParseTree/ParseTree.hpp>

template<unsigned char N>
NaryNode<N>::NaryNode()
	: pt_(new PTree[N]) {}

template<unsigned char N>
NaryNode<N>::~NaryNode()
	{ delete [] pt_; }

template<unsigned char N>
void
NaryNode<N>::delete_r() {
	for(unsigned i = 0; i < N; i++) {
		if(pt_[i]) pt_[i]->delete_r();
	}
}

VarNode::VarNode(PTree _pt) {
	pt_.reserve(5);
	pt_.push_back(_pt);
}

void
VarNode::delete_r() {
	PTList::iterator i;
	for(i = pt_.begin(); i < pt_.end(); i++) {
		if(*i) (*i)->delete_r();
	}
}
