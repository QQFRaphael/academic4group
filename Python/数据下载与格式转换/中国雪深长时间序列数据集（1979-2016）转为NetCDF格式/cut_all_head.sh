#!/bin/sh

for each in `ls precip/*`
do
	echo ${each}
	sed -i "" '1d' ${each}
done
