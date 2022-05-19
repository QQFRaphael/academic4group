from standardization import standardization
from numpy.fft import rfft, irfft

def fourier_filter_high_pass(ts, threshold):
	nt = ts.size
	fourier = rfft(ts, nt)

	cut_f = fourier.copy()
	cut_f[0:threshold+1] = 0.0

	ts_filtered = irfft(cut_f, nt)

	ts_filtered = standardization(ts_filtered)

	return ts_filtered