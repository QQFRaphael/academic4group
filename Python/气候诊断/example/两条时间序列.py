import numpy as np
import matplotlib.pyplot as plt

import sys
sys.path.append("../utils/")
from draw_ts import ts_two


plt.close

fig, ax = ts_two(np.loadtxt("idx-filter.txt"), np.loadtxt("idx-unfilter.txt"), np.arange(1979,2020))

fig.show()
fig.savefig("idx.png",dpi=1000)
