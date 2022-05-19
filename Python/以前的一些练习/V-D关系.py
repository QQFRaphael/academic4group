import numpy as np
import matplotlib.pyplot as plt

D = np.linspace(0, 2e-2, 1000)

wdm_g = 330.0 * D ** 0.8
wdm_h = 285.0 * D ** 0.8
mor_g = 19.3 * D ** 0.37
mor_h = 114.5 * D ** 0.5

fig, ax = plt.subplots()

l1, l2, l3, l4 = ax.plot(D*1000.0, wdm_g, 'g-', D*1000.0, wdm_h, 'r-', D*1000.0, mor_g, 'b-', D*1000.0, mor_h, 'y-')

fig.legend((l1, l2, l3, l4), ('WDM6_G: $330D^{0.8}$, $500kg/m^3$', 'WDM6_H: $285D^{0.8}$, $700kg/m^3$', 'MOR_G: $19.3D^{0.37}$, $400kg/m^3$', 'MOR_H: $114.5D^{0.5}$, $900kg/m^3$'), loc=(0.15,0.65))
ax.set_xlim(0, 20)
ax.set_ylim(0, 17)
ax.set_title('V-D and density')
ax.set_xlabel('$mm$')
ax.set_ylabel('$m/s$')

#plt.show()
plt.savefig("VD.png", dpi=900)