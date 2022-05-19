#ifndef DATA_STRUCTURE
#define DATA_STRUCTURE

namespace Shallow_Water_Model{

class Grid {
	public:
		float u;
		float v;
		float h;

		Grid();
		~Grid();
};

class StaticGrid {
	public:
		float H;
		float f;
		StaticGrid();
		~StaticGrid();
};

}

#endif
