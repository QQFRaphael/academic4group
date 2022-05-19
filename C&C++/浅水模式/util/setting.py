# Possible initial conditions of the height field
UNIFORM_WESTERLY=1;
ZONAL_JET=2;
GAUSSIAN_BLOB=3;
STEP=4;
CYCLONE_IN_WESTERLY=5;
SHARP_SHEAR=6;
EQUATORIAL_EASTERLY=7;
SINUSOIDAL=8;

# Possible orographies
FLAT=0;
SLOPE=1;
GAUSSIAN_MOUNTAIN=2;
SEA_MOUNT=3;

# ------------------------------------------------------------------
# Configuration
g    = 9.81;                # Acceleration due to gravity (m/s2)
f    = 1.e-4;                # Coriolis parameter (s-1)
beta = 1.6e-11;             # Meridional gradient of f (s-1m-1)

orography = FLAT
initial_conditions = ZONAL_JET;
initially_geostrophic = True;    # Can be "True" or "False"
add_random_height_noise = True;  # Can be "True" or "False"

# If you change the number of gridpoints then orography=EARTH_OROGRAPHY
# or initial_conditions=REANALYSIS won't work
nx=254; # Number of zonal gridpoints
ny=50;  # Number of meridional gridpoints

dx=100.0e3; # Zonal grid spacing (m)
dy=dx;      # Meridional grid spacing

