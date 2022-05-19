MATLAB files for making the input height data that goes into the model.


(1) /home/gtg789p/m_files/MERRA6hourly.m --> This MATLAB script reads in several fields from the MERRA dataset and outputs them into .dat files (i.e., binary files) that can be read by MATLAB as well as by FORTRAN programs.  You will need auxiliary files from /home/jason/matlib/ to execute the script.

(2) /home/gtg789p/m_files/MERRA_2004_CAO_heights.m --> This piece of code works to create the input data to the PV model..  The code uses auxiliary functions that are found in /home/jason/matlib/.  These include functions to open and write out the hight data  (both in binary) as well as a function to interpolate below the surface.

(3) /home/gtg789p/PVInversionCode/MERRA_PV/ --> This directory houses the actual FORTRAN files for the PV inversion code specifically tailored for the MERRA data.  The model is broken up into modules for easier processing and keeping track of edits/processes done by the model.  There are four files, all of which need to be compiled at the same time to execute the model.
	
        (a) GlbVars.f90 --> This FORTRAN file houses all of the "global" variables used by different functions in the model.  No modifications should be necessary in this file.  However, several of the "prompts" when the model is run are executed in subroutines located in this file.  So, if you want to make changes to that, then you will have to modify this file.
       
        (b) FileManager.f90 --> This FORTRAN file executes several functions used to open, read, and write data.  All data read and written are done so in binary format (.dat files).  The MATLAB scripts used to process the input data will put the data in the proper format needed to be read by the model.  All files are read from and written to the same directory that the code is housed.  So, make sure all the input data are in the same folder.  If you change this structure, you will have to alter the open statements to put in the complete path where the data are.
	
        (c) InversionCalc.f90 --> The "crux" of the model, this script contains the calculations for the QGPV as well as the code for inverting the PV and getting the heights from the inversion.  The inversion routine/solver is also housed in this file.  There should be no modifications needed to this file unless you start running into issues with converging on a solution.  But this code was run with the Jan 2004 MERRA heights on katahdin and, though it took a long time, there was a solution reached for every time step.
	
        (d)qinversion_main.f90 --> This is the main function for the entire model. It consists of basically a series of subroutine calls to execute various parts of the model (initializing the global variables, reading in the data, calling the inversion routine, etc.).  You should have no modifications to make to this file, unless problems start to arise.  In that case, you will want to strategically place in "print" statements to find out where the program is crashing.

In this directory you will also find MERRAdims2.txt.  This file will need to be in the directory of the code as well to run correctly.  The file houses the longitude points, latitude points, and pressure levels that go along with the MERRA data.  You will need this file as input into the model.

(4) To compile the model for execution:  (command for FORTRAN 90 compiler) -o myprog GlbVars.f90 FileManager.f90 InversionCalc.f90 qinversion.f90.  You MUST compile the files in this order.

(5) To execute the program:  ./myprog

(6) Upon execution, you will received a series of prompts:
       (a) "Please enter the filename with the dimensions for the dataset you are using:"  --> This is the MERRAdims2.txt.  Type the entire path of the file, if needed.
       
       (b) "Enter the generic datafile name for input/output:"  --> When making the input files for the model, you should use a naming convention.  The input height anomalies file is of the form:  zp.(generic name).dat.  The mean heights file is of the form:  hgtmean_(generic name).dat.  For example, I have used zp.jan2004.dat and hgtmean_jan2004.dat, where jan2004 is the generic file name.
       
       (c) "How many arrays will you be analyzing (1 or more)?" --> This prompt is asking for how many time steps you will be doing in the analysis.  For example, if you were doing the entire month of January (31 days) using 4x daily data, then it would be 31*4 = 124.  Note that this number cannot exceed the number of time steps in the file, or you will get a read-in error.
       
       (d)  *********************************************************
            Now define the horizontal and vertical dimensions of the area
            over which the inversion will take place.
            *********************************************************
	    
           Here now will come a series of three prompts.  You must enter domain over which the inversion routine will take place.  More likely than not, you will want to do the whole Northern Hemisphere.  This is preferable as the model is most efficient with Periodic boundary conditions.  The vertical levels are your call.  When entering the longitude and latitude points, be conscious of the limits (check MERRAdims2.txt).  Longitude goes from -180 to 178.75, and latitude goes from -88.75 to 90.  As long as you enter a value in this range, then you will be OK.  Pressure levels should be entered exactly, however.

       (e) *********************************************************
           Now we will define the areas of PV we are interested in for
           use in the inversion routine.
          *********************************************************

         This prompt asks you for the domain of the PV that will be inverted.  This will be a subset of the entire domain you entered before.  You will be asked for pressure levels, longitude points, and latitude points again, as before.  Note that as a check for yourself, if you enter the whole domain in pressure, latitude, and longitude for (d) and (e), you will get back almost ctly the input height anomalies.  You should do this as a check to make sure the code is running correctly (though it will take a LONG time).


