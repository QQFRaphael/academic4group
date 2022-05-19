#!/bin/bash

nthds=140    #1 # 140
nds=5        #1 # 5
exe='./cesm.exe'

cat << EOF > run.sh
#!/bin/bash
yhrun -n ${nthds} -N ${nds} -p TH_HPC1 ${exe}
EOF

chmod u+x run.sh

yhbatch -n ${nthds} -N ${nds} -p TH_HPC1 -J qqf ./run.sh

rm -rf run.sh
