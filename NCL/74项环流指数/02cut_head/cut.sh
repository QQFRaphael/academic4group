#!/bin/sh

for ii in `ls ../ori/*.txt`
do
	awk 'NR>2{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12}' $ii >& ./${ii##*/}
	echo ${ii##*/}
done
