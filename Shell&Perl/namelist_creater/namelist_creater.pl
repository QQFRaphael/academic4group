#!/usr/bin/perl

open(FILE, "namelist.input") or die("No such file");

while($LINE = <FILE>){
    push(@namelist,$LINE);
}
close(FILE);

srand;
@interval=(0.2,0.4,0.6,0.8,1);
foreach $ii (0..$#interval) {
    foreach $jj (1..12) {
        while(1){
            $num=rand($interval[$ii]);
            if( (($ii==0) && ($num ge 0.001)) ) {
                last;
            } else {
                if( $num gt @interval[$ii-1] ) {
                    last;
                }
            }
        }
        $num=sprintf("%.4f", $num);
        push(@eta,$num.",");
    }
}
@eta=reverse sort @eta;
push(@eta,sprintf("%.4f", 0.0));
shift @eta;
unshift(@eta,sprintf("%.4f", 1.0).",");

@namelist[32]=" eta_levels   = @eta[0..4]\n";
@namelist[33]="                @eta[5..9]\n";
@namelist[34]="                @eta[10..14]\n";     
@namelist[35]="                @eta[15..19]\n";     
@namelist[36]="                @eta[20..24]\n";     
@namelist[37]="                @eta[25..29]\n";     
@namelist[38]="                @eta[30..34]\n";     
@namelist[39]="                @eta[35..39]\n";    
@namelist[40]="                @eta[40..44]\n";     
@namelist[41]="                @eta[45..49]\n";     
@namelist[42]="                @eta[50..54]\n";     
@namelist[43]="                @eta[55..59]\n";     
@namelist[44]="                @eta[60]\n";     

print @namelist;
