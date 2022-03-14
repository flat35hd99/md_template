#!/bin/bash -e
prefix=${YTVA_DARK_PREFIX}

module purge
source $prefix/util/load_amber_gpu

PMEMD=pmemd.cuda
run=$( printf %02d $1 )
output=$prefix/3sampling/output/${run}

mkdir -p $output

echo "job start time" `date +'%Y%m%d %H:%M:%S'` >> $output/time.log

# Sampling system in multiple steps
coodinates=$prefix/2equilibrium/output/$run/npt/md.rst
for step in pre_sampling_0 pre_sampling_1 sampling;do
  mkdir -p $output/$step
  cd $output/$step
  ${PMEMD} \
    -O \
    -i $prefix/3sampling/input/${step}.input \
    -p ${prefix}/0structure/output/system.prmtop \
    -c $coodinates \
    -ref ${prefix}/0structure/output/system.crd \
    -r md.rst \
    -o md.out \
    -x md.crd.nc \
    -inf md.info \
    -l md.log
  coodinates=$output/$step/md.rst # Update initial structure for the next step
done

echo "job end time  " `date +'%Y%m%d %H:%M:%S'` >> $output/time.log
