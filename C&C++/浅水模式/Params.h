#ifndef PARAMS
#define PARAMS

#include <math.h>

namespace Shallow_Water_Model {

static float g        = 9.81;        // Acceleration due to gravity (m/s2)

static const int nx   = 254;         // Number of zonal gridpoints
static const int ny   = 50;          // Number of meridional gridpoints

static float delta_x  = 100.e3;      // Zonal grid spacing (m)
static float delta_y  = 100.e3;      // Meridional grid spacing
static float delta_t  = 60;          // Timestep (s)

static float forecast_days = 4;      // Forecast length (day)
static float output_interval = 60;   // Output time interval (minutes)

static float forecast_length = forecast_days * 24.0 * 60.0 * 60.0;              // Forecast length (s)
static const int nt   = ceil(forecast_length / delta_t + 1.0);                  // Number of timesteps
static const int noutput = ceil(nt / floor(output_interval * 60.0 / delta_t));  // Number of output frames
}

#endif
