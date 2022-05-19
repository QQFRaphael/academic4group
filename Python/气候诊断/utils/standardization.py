import numpy as np

def standardization(ts):
    mu = np.mean(ts, axis=0)
    sigma = np.std(ts, axis=0)

    return (ts - mu) / sigma