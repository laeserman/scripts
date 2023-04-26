#!/usr/bin/perl -w
use strict;
use Cwd;
#modified only slightly from Karolina Heyduk - heyduk@uga.edu - 2014

my $wd = getcwd;

my @files = glob("*.fasta.prank.best.fas"); 
foreach my $file (@files) {
    my $count = 0;
    open IN, "<$file";
    while (<IN>) {
        chomp;
        my $line = $_;
        if ($line =~ ">") {
            $count++;
            #print "$count";
        }
        else {
            next;
        }
    }
    my $half = int(($count/2)+1); #calculating half of the alignment columns for filtering - modify as you'd like here or below by replacing $half with an actual numerical value.
    open OUT, ">$file.gb.sh";
    #Edit to match your file path to Gblocks
    print OUT "~/Programs/Gblocks_0.91b/Gblocks $file -t=d -b1=$half -b2=$half -b3=25 -b4=10 -b5=a -e gb\n";
    close OUT;
    system "bash $file.gb.sh";
}
