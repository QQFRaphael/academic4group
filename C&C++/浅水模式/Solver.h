#ifndef SOLVER
#define SOLVER

#include "Params.h"
#include "Data_Structure.h"

namespace Shallow_Water_Model {

class Solver {
	public:
		virtual void run(){};
};

class Lax_Wendroff_Solver: public Solver {
	public:
		void scheme();
		void set_boundary();
		void save();
		void initialize();
		float find_max_wind_speed(float uwnd[ny][nx], float vwnd[ny][nx]);
		virtual void run();
};

}
#endif
