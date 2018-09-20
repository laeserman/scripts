#!/usr/bin/perl

use strict;
use warnings;

#This script generates a bed file from blast output
#Assumes you want to pull seqs out of the blast db - modify line 12 if you want to pull seqs from the query
#assumes you have blast tabular output saved as *.out
#L. Eserman 2016, leserman@uga.edu, (with help from M. Hwang)

while (my $blastfile = glob("*.out")) {
    system "awk '{print \$2,\"\t\",\$9,\"\t\",\$10,\"\t\",\$1}' $blastfile > $blastfile.bed";
    system "sed -i 's/ //g' *.bed";
    print "$blastfile \n";
}


#open bed files
#define columns in the bed file as variables
#print line if $sstop is greater than $sstart
#otherwise print $sstop before $sstart
#sstart and sstop are start and stop coordinates in the subject (reference genome) file, these were taken from blast output

# Get array of all filenames in directory that end in .bed 
my @files = glob("*.bed");

for my $bedfile (@files) {
    open IN, '<', "$bedfile"; # Open your bed file

    open OUT, '>', "$bedfile.fix.bed"; # Create a new bed file

    # Iterate through lines of your bed file
    while (<IN>) {  
	chomp;
	my ($subID, $sstart, $sstop, $queryID) = split /\s+/, $_;

	if ($sstart < $sstop) {
	    print OUT "$_\n";
	}
	else {
	    print OUT "$subID\t$sstop\t$sstart\t$queryID\n";
	}
    }
    close OUT;
    print "$bedfile \n";
}
close IN;

