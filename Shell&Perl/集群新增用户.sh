#!/bin/bash
for USER in hxmdo
do
	useradd $USER
	echo "111111" | passwd  --stdin  $USER

	for i in 01 02 03 04 05 06 07 08 09 `seq 10 16`
	do
		scp hn:/etc/passwd  n$i:/etc
		scp hn:/etc/shadow  n$i:/etc
		scp hn:/etc/group  n$i:/etc
		cp -pr /root/.ssh   /home/$USER/
		echo "n$i $USER"  >> /home/$USER/.rhosts
		chown $USER.$USER  /home/$USER/  -R
	done
done