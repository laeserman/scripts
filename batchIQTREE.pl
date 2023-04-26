#!/usr/bin/perl
#Modified from a script by Karolina Heyduk 

use strict;
use Cwd;
use Bio::SeqIO;
use Array::Utils qw(:all);


my $outfile = $ARGV[0]; #file of outgroup IDs
my $boots = $ARGV[1]; #number of bootstrap replicates
my $ending = $ARGV[2]; #file ending
my @files = glob("*$ending");
my @outgroups;
my $wd = getcwd;

open IN, "<$outfile"; #put all outgroups into an array
while (<IN>) {
        chomp;
        my $line = $_;
        push(@outgroups, $line);
        }
close IN;


for my $file (@files) {
        open OUT, ">>$file.mod";
        my $geneID;
        my @headers;
        my $stop = 0;
    my $infile = Bio::SeqIO -> new(-file => "$file", -format => "fasta", -alphabet => "DNA"); #this line calls bioperl and defines the infile as a bioperl variable
    while (my $io_obj = $infile -> next_seq() ) {
                    my $header = $io_obj->id();
                my $seq = $io_obj->seq();
                push(@headers, $header);
                if ($seq ~~ /[ACTG]/) {
                        print OUT ">$header\n$seq\n"; #makes a modified file that removes blank sequences
                        }
                else {
                        next;
                        }
                }
        close OUT;

        my $out;
        my $count = 0;
        foreach my $outgroup (@outgroups) {
                if($outgroup ~~ @headers) {
                        if ($count < 1) {
                                $out.="$outgroup" . "_";
                                $count = 1;
                        }
                        else {
                                next;
                        }
                }
                else {
                        next;
                        }
                }

        my @int = intersect(@outgroups, @headers);
        if (@int == 0) {
                print "$file has no outgroup!\n";
                $stop = 1;
                }
                        if ($stop == 0) {
        my $divider = ".";
    my $position = index($file, $divider, 0);
    my $ID = substr($file, 0, $position);
        print "$ID\n";
        open OUT2, ">>run.$ID\_raxml.sh";
        print OUT2 "iqtree -s $file.mod -bb $boots -wbt";
        close OUT2;
        system "bash ./run.$ID\_raxml.sh";
        }

        else {
                next;
                } 
}
