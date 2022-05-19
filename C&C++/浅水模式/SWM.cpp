#include "Solver.h"

using namespace Shallow_Water_Model;

int main(){

	Lax_Wendroff_Solver mysolver;

	mysolver.run();

	return 0;
}
