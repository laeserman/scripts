#Script written using ChatGPT with the prompt "Write a perl script using bioperl to input a fasta file, measure the length of each sequence, output the name of each sequence along with the length"

#!/usr/bin/perl
use strict;
use warnings;
use Bio::SeqIO;

# Check for the correct number of command-line arguments
if (@ARGV != 1) {
    die "Usage: $0 <input_fasta_file>\n";
}

my $input_file = $ARGV[0];

# Create a Bio::SeqIO object to read the input FASTA file
my $seqio = Bio::SeqIO->new(
    -file   => $input_file,
    -format => 'fasta'
    );

# Process each sequence in the input file
while (my $seq = $seqio->next_seq) {
    my $seq_name = $seq->display_id;
    my $seq_length = $seq->length;

    print "Sequence: $seq_name, Length: $seq_length\n";
}
