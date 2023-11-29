#This perl script written by ChatGPT using the prompt "Write a perl script using the bioperl module to input multiple fasta files all with the .fasta ending, select the longest sequence from each file, and output the longest sequences to a new file". The script was subsequently edited manually by Lauren Eserman-Campbell
#Usage: perl find_longest_sequences.pl output.fasta *.fasta (*.fasta being all your input gene files)

#!/usr/bin/perl

use strict;
use warnings;
use Bio::SeqIO;

# Check for the correct number of command-line arguments
if (@ARGV < 2) {
    die "Usage: $0 <output_file> <input_files>\n";
}

# Get the output file name (the first argument)
my $output_file = shift @ARGV;

# Create a Bio::SeqIO object for writing the longest sequences to the output file
my $outseq = Bio::SeqIO->new(
    -file   => ">$output_file",
    -format => 'fasta'
);

# Process each input file
foreach my $input_file (@ARGV) {
    my $inseq = Bio::SeqIO->new(
        -file   => $input_file,
        -format => 'fasta'
    );

    my $max_length = 0;
    my $longest_seq;

    # Iterate through sequences in the input file
    while (my $seq = $inseq->next_seq) {
        my $seq_length = $seq->length;

        if ($seq_length > $max_length) {
            $max_length = $seq_length;
            $longest_seq = $seq;
        }
    }

    if ($longest_seq) {
        # Write the longest sequence to the output file
        $outseq->write_seq($longest_seq);
        print "Longest sequence from $input_file added to $output_file\n";
    } else {
        print "No sequences found in $input_file\n";
    }
}

print "Processing complete.\n";
