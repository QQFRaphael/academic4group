import numpy as np
import matplotlib.pyplot as plt
from moviepy.video.io.bindings import mplfig_to_npimage
import moviepy.editor as mpy

# Set this to "True" to save each frame as a png file
plot_frames = True;

delta_t  = 60;          # Timestep (s)
forecast_days = 4;      # Forecast length (day)
output_interval = 60;   # Output time interval (minutes)
forecast_length = forecast_days * 24.0 * 60.0 * 60.0;              # Forecast length (s)
nt   = np.ceil(forecast_length / delta_t + 1.0);                   # Number of timesteps
noutput = int(np.ceil(nt / np.fix(output_interval * 60.0 / delta_t)));  # Number of output frames
nx   = 254;         # Number of zonal gridpoints
ny   = 50;          # Number of meridional gridpoints
delta_x  = 100.e3;      # Zonal grid spacing (m)
delta_y  = 100.e3;      # Meridional grid spacing
dx = delta_x
dy = delta_y

ufile = open('../out_data/u_out.txt','r');
vfile = open('../out_data/v_out.txt','r');
hfile = open('../out_data/h_out.txt','r');
tfile = open('../out_data/t_out.txt','r');

u_save = np.zeros([nx,ny,noutput]);
v_save = np.zeros([nx,ny,noutput]);
h_save = np.zeros([nx,ny,noutput]);
t_save = np.zeros([noutput]);

from setting import *

x=np.mgrid[0:nx]*dx; # Zonal distance coordinate (m)
y=np.mgrid[0:ny]*dy; # Meridional distance coordinate (m)
[Y,X] = np.meshgrid(y,x); # Create matrices of the coordinate variables


for ii in range(noutput):
    for jj in range(ny):
        for kk in range(nx):
            line = float(ufile.readline().strip('\n'))
            u_save[kk,jj,ii] = line

            line2 = float(vfile.readline().strip('\n'))
            v_save[kk,jj,ii] = line2

            line3 = float(hfile.readline().strip('\n'))
            h_save[kk,jj,ii] = line3
    line4 = float(tfile.readline().strip('\n'))
    t_save[ii] = line4

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

#f,(ax1, ax2) = plt.subplots(2, sharex=True, sharey=False)
f=plt.figure()
ax1=f.add_subplot(211)
ax2=f.add_subplot(212)

ax1.autoscale(enable=True, axis='y', tight=True)

x=np.mgrid[0:nx]*dx;
y=np.mgrid[0:ny]*dy;
plot_height_range = np.array([9500., 10500.]);

# Axis units are thousands of kilometers (x and y are in metres)
x_1000km = x * 1.e-6
y_1000km = y * 1.e-6

# Set colormap to have 64 entries
ncol=64;

# Interval between arrows in the velocity vector plot
interval = 6;

# Decide whether to show height in metres or km
if np.mean(plot_height_range) > 1000:
   height_scale = 0.001;
   height_title = 'Height (km)';
else:
   height_scale = 1;
   height_title = 'Height (m)';


#print('Maximum orography height = %f m' % np.max(H[:]));
u = np.squeeze(u_save[:,:,0]);
vorticity = np.zeros(np.shape(u));

# Loop through the frames of the animation
for it in range(0,noutput):

   # Extract the height and velocity components for this frame
   h = np.squeeze(h_save[:,:,it]);
   u = np.squeeze(u_save[:,:,it]);
   v = np.squeeze(v_save[:,:,it]);

   # Compute the vorticity
   vorticity[1:-1,1:-1] = (1./dy)*(u[1:-1,0:-2]-u[1:-1,2:]) \
     + (1./dx)*(v[2:,1:-1]-v[0:-2,1:-1]);
   # First plot the height field

   if it==0:
    
      # Plot the height field
      im=ax1.imshow(np.transpose(h+H)*height_scale, \
        extent=[np.min(x_1000km),np.max(x_1000km),np.min(y_1000km),np.max(y_1000km)], \
        cmap="bwr")
      # Set other axes properties and plot a colorbar
      cb1=f.colorbar(im,ax=ax1)
      # Contour the terrain:
      cs=ax1.contour(x_1000km,y_1000km,np.transpose(H),levels=range(1,11001,1000),colors='k')
      
      # Plot the velocity vectors
      Q = ax1.quiver(x_1000km[2::interval],y_1000km[2::interval], \
         np.transpose(u[2::interval,2::interval]), \
         np.transpose(v[2::interval,2::interval]), scale=5e2, scale_units='xy',pivot='mid')
      ax1.set_ylabel('Y ($10^3$ km)');
      ax1.set_title(height_title);
      tx1=ax1.text(0, np.max(y_1000km), 'Time = %.1f hours' % (t_save[it]/3600.));
      
      
      # Now plot the vorticity
      im2=ax2.imshow(np.transpose(vorticity), \
        extent=[np.min(x_1000km),np.max(x_1000km),np.min(y_1000km),np.max(y_1000km)], \
        cmap="bwr")
      # Set other axes properties and plot a colorbar
      cb2=f.colorbar(im2,ax=ax2)
      ax2.set_xlabel('X ($10^3$ km)');
      ax2.set_ylabel('Y ($10^3$ km)');
      ax2.set_title('Relative vorticity (s$^{-1}$)');
      
   else:
      # top plot:
      im.set_data(np.transpose(H+h)*height_scale)
      cs.set_array(np.transpose(h))
      Q.set_UVC(np.transpose(u[2::interval,2::interval]), \
               np.transpose(v[2::interval,2::interval]))
      tx1.set_text('Time = %.1f hours' % (t_save[it]/3600.));
      
      # bottom plot:
      im2.set_data(np.transpose(vorticity))
   
   im.set_clim((plot_height_range*height_scale));
   im2.set_clim((-3e-4,3e-4));
   ax1.axis((0., np.max(x_1000km), 0., np.max(y_1000km)));
   ax2.axis((0., np.max(x_1000km), 0., np.max(y_1000km)));

   # To make an animation we can save the frames as a 
   # sequence of images
   if plot_frames:
      plt.savefig('time-%03d.png' % it,format='png',dpi=1000) 
