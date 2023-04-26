#!/usr/bin/perl
use strict;
#modified from a script by Karolina Heyduk

#run in directory where reads are located

my $adapters = $ARGV[0]; #file with adapter sequences you wish to trim, one per line
my $list = $ARGV[1]; #read to ID index file
my %read1;
my %read2;
my @libIDs;

#read library index file, store R1 and R2 in hashes
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
    open OUT, ">$libID.trim.sh";
    #Modify path to Trimmomatic
    print OUT "#!/bin/bash\njava -jar ~/Programs/Trimmomatic-main/dist/jar/trimmomatic-0.40-rc1.jar PE -threads 4 -phred33 $read1{$libID} $read2{$libID} $libID\_paired\_R1.fastq $libID\_unpaired\_R1.fastq $libID\_paired\_R2.fastq $libID\_unpaired\_R2.fastq ILLUMINACLIP:$adapters:2:30:10 LEADING:10 TRAILING:10 MINLEN:40";
    close OUT;
    system "bash $libID.trim.sh"
}
