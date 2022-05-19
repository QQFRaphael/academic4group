import numpy as np
import matplotlib.pyplot as plt

def ts_one(ts, year):
	fig = plt.figure(figsize=(12,6))
	ax = fig.subplots(1, 1)

	b = ax.bar(year,ts ,color='orange', width=0.4)

	for bar,height in zip(b,ts):
		if height<0: bar.set(color='green')

	ax.axhline(y=0, linewidth=1, color='k',linestyle='-')

	plt.ylim(-3, 3)
	plt.xlim(np.min(year)-1, np.max(year)+1)

	plt.yticks(size = 18)
	plt.xticks(size = 18) 

	return fig, ax


def ts_two(ts1, ts2, year):
	fig = plt.figure(figsize=(12,6))
	ax = fig.subplots(1, 1)

	c = ax.bar(year,ts2,color='white', width=0.8, edgecolor="k")

	b = ax.bar(year,ts1,color='orange', width=0.4)

	for bar,height in zip(b,ts1):
		if height<0: bar.set(color='green')

	ax.axhline(y=0, linewidth=1, color='k',linestyle='-')

	plt.ylim(-3, 3)
	plt.xlim(np.min(year)-1, np.max(year)+1)

	plt.yticks(size = 18)
	plt.xticks(size = 18) 

	return fig, ax