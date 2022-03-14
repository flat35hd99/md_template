#!/bin/bash

run_start=$1
run_end=$2

pjsub -N ytva_equ_${run_start}_${run_end} \
  --bulk --sparam ${run_start}-${run_end} \
  $YTVA_DARK_PREFIX/2equilibrium/job.sh
