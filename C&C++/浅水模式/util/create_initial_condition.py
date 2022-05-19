import numpy as np
import sys
from setting import *

x=np.mgrid[0:nx]*dx; # Zonal distance coordinate (m)
y=np.mgrid[0:ny]*dy; # Meridional distance coordinate (m)
[Y,X] = np.meshgrid(y,x); # Create matrices of the coordinate variables

# Create the orography field "H"
if orography == FLAT:
   H = np.zeros((nx, ny));
elif orography == SLOPE:
   H = 9000.*2.*np.abs((np.mean(x)-X)/np.max(x));
elif orography == GAUSSIAN_MOUNTAIN:
   std_mountain_x = 5.*dx; # Std. dev. of mountain in x direction (m)
   std_mountain_y = 5.*dy; # Std. dev. of mountain in y direction (m)
   H = 4000.*np.exp(-0.5*((X-np.mean(x))/std_mountain_x)**2. \
                  -0.5*((Y-np.mean(y))/std_mountain_y)**2.);
elif orography == SEA_MOUNT:
   std_mountain = 40.0*dy; # Standard deviation of mountain (m)
   H = 9250.*np.exp(-((X-np.mean(x))**2.+(Y-0.5*np.mean(y))**2.)/(2.*std_mountain**2.));
else:
   print('Don''t know what to do with orography=' + np.num2str(orography)); 
   sys.exit()

# Create the initial height field 
if initial_conditions == UNIFORM_WESTERLY:
   mean_wind_speed = 20.; # m/s
   height = 10000.-(mean_wind_speed*f/g)*(Y-np.mean(y)); 
elif initial_conditions == SINUSOIDAL:
   height = 10000.-350.*np.cos(Y/np.max(y)*4.*np.pi);
elif initial_conditions == EQUATORIAL_EASTERLY:
   height = 10000. - 50.*np.cos((Y-np.mean(y))*4.*np.pi/np.max(y));
elif initial_conditions == ZONAL_JET:
   height = 10000. - np.tanh(20.0*((Y-np.mean(y))/np.max(y)))*400.;
elif initial_conditions == GAUSSIAN_BLOB:
   std_blob = 8.0*dy; # Standard deviation of blob (m)
   height = 9750. + 1000.*np.exp(-((X-0.25*np.mean(x))**2.+(Y-np.mean(y))**2.)/(2.* \
                                                     std_blob**2.));
elif initial_conditions == STEP:
   height = 9750.*np.ones((nx, ny));
   height[where((X<np.max(x)/5.) & (Y>np.max(y)/10.) & (Y<np.max(y)*0.9))] = 10500.;
elif initial_conditions == CYCLONE_IN_WESTERLY:
   mean_wind_speed = 20.; # m/s
   std_blob = 7.0*dy; # Standard deviation of blob (m)
   height = 10000.-(mean_wind_speed*f/g)*(Y-np.mean(y)) \
       - 500.*np.exp(-((X-0.5*np.mean(x))**2.+(Y-np.mean(y))**2.)/(2.*std_blob**2.));
   max_wind_speed = 20.; # m/s
   height = 10250.-(max_wind_speed*f/g)*(Y-np.mean(y))**2./np.max(y) \
       - 1000.*np.exp(-(0.25*(X-1.5*np.mean(x))**2.+(Y-0.5*np.mean(y))**2.)/(2.*std_blob**2.));
elif initial_conditions == SHARP_SHEAR:
   mean_wind_speed = 50.; # m/s
   height = (mean_wind_speed*f/g)*np.abs(Y-np.mean(y));
   height = 10000.+height-np.mean(height[:]);
else:
   print("Don't know what to do with initial_conditions=%f" % initial_conditions); 
   sys.exit()

# Coriolis parameter as a matrix of values varying in y only
F = f+beta*(Y-np.mean(y));

# Initialize the wind to rest
u=np.zeros((nx, ny));
v=np.zeros((nx, ny));

# We may need to add small-amplitude random noise in order to initialize 
# instability
if add_random_height_noise:
   r,c=np.shape(height)
   height = height + 1.0*np.random.randn(r,c)*(dx/1.0e5)*(np.abs(F)/1e-4);


if initially_geostrophic:

   # Centred spatial differences to compute geostrophic wind
   u[:,1:-1] = -(0.5*g/(F[:,1:-1]*dx)) \
       * (height[:,2:]-height[:,0:-2]);
   v[1:-1,:] = (0.5*g/(F[1:-1,:]*dx)) \
       * (height[2:,:]-height[0:-2,:]);
   # Zonal wind is periodic so set u(1) and u(end) as dummy points that
   # replicate u(end-1) and u(2), respectively
   u[[0 ,-1],:] = u[[1 ,-2],:];
   # Meridional wind must be zero at the north and south edges of the
   # channel 
   v[:,[0, -1]] = 0.;

   # Don't allow the initial wind speed to exceed 200 m/s anywhere
   max_wind = 200.;
   u[np.where(u>max_wind)] = max_wind;
   u[np.where(u<-max_wind)] = -max_wind;
   v[np.where(v>max_wind)] = max_wind;
   v[np.where(v<-max_wind)] = -max_wind;


# Define h as the depth of the fluid (whereas "height" is the height of
# the upper surface)
h = height - H;

np.savetxt("../init_data/f.txt",F)
np.savetxt("../init_data/u.txt",u)
np.savetxt("../init_data/v.txt",v)
np.savetxt("../init_data/h.txt",h)
np.savetxt("../init_data/topo.txt",H)
