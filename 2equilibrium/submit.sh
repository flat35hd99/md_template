#!/bin/bash

run_start=$1
run_end=$2

pjsub -N yd_2_${run_start}_${run_end} \
  --bulk --sparam ${run_start}-${run_end} \
  $YTVA_DARK_PROTONATED_PREFIX/2equilibrium/job.sh
