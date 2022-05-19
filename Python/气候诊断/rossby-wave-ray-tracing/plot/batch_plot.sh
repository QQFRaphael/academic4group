#!/bin/bash

for ii in `ls Output/raypath*`; do python plot2.py  ${ii##*/}; done
