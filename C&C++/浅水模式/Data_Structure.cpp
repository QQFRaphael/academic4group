#include "Data_Structure.h"

namespace Shallow_Water_Model {

Grid::Grid() {
	u = 0;
	v = 0;
	h = 0;
};

Grid::~Grid(){};

StaticGrid::StaticGrid() {
	H = 0;
	f = 0;
};

StaticGrid::~StaticGrid(){};

}
