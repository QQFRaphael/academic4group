#!/bin/sh
#PBS -l nodes=8:ppn=16
echo "This jobs is "$PBS_JOBID@$PBS_QUEUE
NSLOTS=`cat ${PBS_NODEFILE} | wc -l`
cd $PBS_O_WORKDIR

echo "nmlgb "
/share/apps/openmpi-1.4.5/bin/mpirun -machinefile $PBS_NODEFILE -np $NSLOTS ./real.exe