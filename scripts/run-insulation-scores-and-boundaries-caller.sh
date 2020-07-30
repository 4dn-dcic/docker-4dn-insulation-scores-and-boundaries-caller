#!/bin/bash

INPUT=$1
OUTDIR=$2
CHROMSIZES=$3
BOUNDARIES_CUTOFF_1=$4
BOUNDARIES_CUTOFF_2=$5
BINSIZE=$6
WINDOWSIZE=$7
CUTOFF=$8
PIXELS_FRAC=$9


FILE_BASE=$(basename $INPUT)
FILE_NAME=${FILE_BASE%%.*}

if [ ! -d "$OUTDIR" ]
then
    mkdir $OUTDIR
fi

python /usr/local/bin/get_insulation_scores_and_boundaries.py  --binsize $BINSIZE --window $WINDOWSIZE --cutoff $CUTOFF --pixels_frac $PIXELS_FRAC  $INPUT $OUTDIR $FILE_NAME $BOUNDARIES_CUTOFF_1 $BOUNDARIES_CUTOFF_2

for eachfile in $OUTDIR/*.bed
do
  gzip $eachfile
done
