#!/bin/bash
#!/bin/bash
DIRECTORIES=~/yewa_genome_data/usftp21.novogene.com/01.RawData/*

for d in $DIRECTORIES
do
	wc $d/*.txt &
done
