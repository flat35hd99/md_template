#!/bin/bash
prefix=${YTVA_DARK_PROTONATED_PREFIX}

module purge
source $prefix/util/load_amber_gpu

PMEMD=pmemd.cuda
run=$( printf %02d $1 )
output=$prefix/2equilibrium/output/${run}

mkdir -p $output

echo "job start time" `date +'%Y%m%d %H:%M:%S'` >> $output/time.log

# Equilibrium system in multiple steps
coodinates=${prefix}/1minimization/output/optimize_whole_system/md.rst
for step in heat nvt npt;do
  mkdir -p $output/$step
  cd $output/$step
  ${PMEMD} \
    -O \
    -i $prefix/2equilibrium/input/${step}.input \
    -p $prefix/0structure/output/system.prmtop \
    -c $coodinates \
    -ref $prefix/0structure/output/system.crd \
    -r md.rst \
    -o md.out \
    -x md.crd.nc \
    -inf md.info \
    -l md.log
  coodinates=$output/$step/md.rst # Update initial structure for the next step
done

echo "job end time  :" `date +'%Y%m%d %H:%M:%S'` >> $output/time.log