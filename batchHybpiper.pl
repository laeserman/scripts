#!/usr/bin/perl
use strict;
#Lauren Eserman 2019
#Modified from a script from Karolina Heyduk

#run in directory where reads are located
#list should be tab delimited, R1 and R2 files should be on separate lines
#libID     libID_R1.fasta
#libID     libID_R2.fasta

my $list = $ARGV[0]; #read to ID index file
my %read1;
my %read2;
my @libIDs;

open IN, "<$list";
while (<IN>) {
    chomp;
    my ($libID, $readID) = split /\t/;
    if ($readID =~ 'R1') {
        $read1{$libID} = $readID;
        print "$libID\t$readID\n";
        if ($libID ~~ @libIDs) {
            next;
        }
        else {
            push(@libIDs, $libID);
        }
    }
    elsif ($readID =~ 'R2') {
        $read2{$libID} = $readID;
        print "$libID\t$readID\n";
    }
}
close IN;

for my $libID (@libIDs) {
    open OUT, ">$libID.hybpiper.sh";
    print OUT "python reads_first.py -b mag_kim.fasta -r $libID\_paired\_R1.fastq $libID\_paired\_R2.fastq --prefix $libID --bwa";
    close OUT;
    system "bash $libID.hybpiper.sh";
    system "python cleanup.py $libID";
}
