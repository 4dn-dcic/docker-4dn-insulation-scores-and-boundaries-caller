#!/bin/bash

INPUT=$1
OUTDIR=$2
BINSIZE=$3
WINDOWSIZE=$4
BOUNDARIES_WEAK=$5
BOUNDARIES_STRONG=$6
CUTOFF=$7
PIXELS_FRAC=$8


FILE_BASE=$(basename $INPUT)
FILE_NAME=${FILE_BASE%%.*}

if [ ! -d "$OUTDIR" ]
then
    mkdir $OUTDIR
fi

python /usr/local/bin/get_insulation_scores_and_boundaries.py  --binsize $BINSIZE --window $WINDOWSIZE --bweak $BOUNDARIES_WEAK --bstrong $BOUNDARIES_STRONG --cutoff $CUTOFF --pixels_frac $PIXELS_FRAC  $INPUT $OUTDIR $FILE_NAME

gzip $OUTDIR/*.bed
