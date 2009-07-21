#include <iostream>
#include <Lexer.hpp>

using namespace std;

int main(int argc, const char* argv[]) {

	if (!argc) {
		cerr << "No arguments" << endl;
		return 0;
	}
    Lexer l(argv[1]);
    cout << "using input " << argv[1] << endl;
    return 0;
}
