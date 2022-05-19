#!/bin/sh

data = []
with open("./eof-ts.txt","r") as ff:
    for line in ff:
        data.append(float(line))

left = data[0:26]
right = data[26:]

data.sort()

u_i = 0
W = 0
for ii in range(1,len(data)+1):
    if data[ii-1] in left:
        u_i = 1
    else:
        u_i = 0
    W = W + ii * u_i

E_W = 0.5 * len(left) * (len(left) + len(right) + 1)

V_W = 1. / 12. * len(left) * len(right) * (len(left) + len(right) + 1)

n = len(data) // 2

u_i = 0
A = 0
for ii in range(1,n+1):
    if data[ii-1] in left:
        u_i = 1
    else:
        u_i = 0
    A = A + ii * u_i

for ii in range(n+1, len(data)+1):
    if data[ii-1] in left:
        u_i = 1
    else:
        u_i = 0
    A = A + (len(data) - ii + 1) * u_i

E_A = 1.0 / 4.0 * len(left) * (len(left) + len(right) + 2)

V_A = (len(left) * len(right)) * (len(left) + len(right) - 2) * (len(left) + len(right) + 2) / 48.0 / (len(left) + len(right) - 1)

HK = (W - E_W)**2 / V_W + (A - E_A)**2 / V_A

print(HK)
