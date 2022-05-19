import numpy as np

def rmse(predictions, targets):
    return np.sqrt(((predictions - targets) *(predictions - targets)).mean())
