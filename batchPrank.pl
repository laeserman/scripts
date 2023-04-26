#!/usr/bin/perl
use strict;
use warnings;
use Cwd;

#Useage: perl batchPrank.pl list.txt

#list = List of file names to run through Prank
my $list = $ARGV[0];
my @ids;
my $wd = getcwd;

open IN, "<$list";
while (<IN>) {
    chomp;
    my $line = $_;
    push (@ids, $line);
}

foreach my $id (@ids) {
    open OUT, ">>$id.prank.sh";
    print OUT "prank -d=$id -DNA -o=$id.prank";
    close OUT;
    system "bash $id.prank.sh";
}
