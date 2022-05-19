#!/usr/bin/perl

open(FILE, $ARGV[0]) or die("No such file");

while($LINE = <FILE>){
	if ($LINE =~ /平方米\|/) {
		$LINE=~s/^ +//; 
		$LINE=~s/平方米\|/ /;
		$LINE=~s/室/ /;
		$LINE=~s/厅\|/ /;
		$LINE=~s/元\/m²\|/ /;
		$LINE=~s/\(共.*层\)\|/ /;
		$LINE=~s/地下/0/;
		$LINE=~s/共.*层\|/1 /;    #5层以下
		$LINE=~s/低层/2/;
		$LINE=~s/中层/3/;
		$LINE=~s/高层/4/;
		$LINE=~s/\(共.*层\)//;
		$LINE=~s/年建造//;
		$tmp=not($LINE =~ /\|/ || $LINE =~ /层/);
		if ($tmp) {
			push(@house,$LINE);
		}
	}
}
close(FILE);

print @house;