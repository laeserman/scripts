#This perl script written by ChatGPT using the prompt "Write a perl script to load in a fasta file, extract the longest DNA sequence, and write the output to a new file. Use the bioperl module" with subsequent manual edits by Lauren Eserman-Campbell

use strict;
use Bio::SeqIO;

# Input and output file names
my $input_file = $ARGV[0];
my $output_file = $ARGV[1];

# Create a Bio::SeqIO object for reading the input FASTA file
my $seqio = Bio::SeqIO->new(-file => $input_file, -format => 'fasta');

# Initialize variables to track the longest sequence
my $longest_seq = undef;
my $max_length = 0;

# Iterate through the sequences in the input file
while (my $seq = $seqio->next_seq) {
    my $sequence = $seq->seq;
    my $length = length($sequence);

    if ($length > $max_length) {
	$max_length = $length;
	$longest_seq = $seq;
    }
}

if ($longest_seq) {
    # Create a Bio::SeqIO object for writing the output FASTA file
    my $outseq = Bio::SeqIO->new(-file => ">$output_file", -format => 'fasta');

    # Write the longest sequence to the output file
    $outseq->write_seq($longest_seq);
    print "Longest sequence written to $output_file\n";
} else {
    print "No sequences found in the input file\n";
}
