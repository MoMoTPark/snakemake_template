#!/usr/bin/env python

from sys import argv

def convert_to_fasta(input_file, output_file):
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        counter = 1
        for line in infile:
            line = line.strip()  # Remove any leading/trailing whitespace
            if line:  # Ensure the line is not empty
                outfile.write(f">sequence{counter}\n{line}\n")
                counter += 1

in_file = argv[1]
out_file = argv[2]
convert_to_fasta(in_file, out_file)