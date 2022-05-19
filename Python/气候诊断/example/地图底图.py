import matplotlib.pyplot as plt

import cartopy.crs as ccrs


fig = plt.figure(figsize=(10, 5))
ax = fig.add_subplot(1, 1, 1, projection=ccrs.Orthographic(central_longitude=0.0, central_latitude=90.0))


# make the map global rather than have it zoom in to
# the extents of any plotted data
ax.set_global()
ax.stock_img()
ax.coastlines()

plt.show()
plt.savefig("show.png", dpi=1000)

