#!/bin/sh -xeu
#PJM -L rscgrp=fx-debug
#PJM -L elapse=01:00:00
#PJM --mpi proc=1
#PJM -j

# Note: This script has no compatibility with other environment like YtvA(light)
# If you want to reuse this script, please check not only settings but also antechamber options.

# setting
ligand_name=FMN
charge=-2
multiplicity=1

prefix=$YTVA_DARK_PREFIX
# input file
gaussian_esp_file=$prefix/FMN/output/B3LYP_dp_19/${ligand_name}.esp
modified_pdb_file=$prefix/0structure/modifid.pdb
# output file
output_dir=$prefix/0structure/output
mol2_file=$output_dir/${ligand_name}.mol2
prep_file=$output_dir/${ligand_name}.prep
frcmod_file=$output_dir/${ligand_name}.frcmod

# Create output directory and log directory
if [ ! -e $output_dir ]; then mkdir -p $output_dir; fi
if [ ! -e $prefix/0structure/log ]; then mkdir -p $prefix/0structure/log; fi

source $prefix/util/load_amber

cd $prefix/0structure
echo "Convert gaussian output file into resp charge file(mol2)"
antechamber -i $gaussian_esp_file \
           -fi gesp \
           -o $mol2_file \
           -fo mol2 \
           -c resp \
           -at gaff2 \
           -nc $charge \
           -m $multiplicity \
           -rn $ligand_name \
           -pf y &> log/convert_gesp_to_mol2.log

echo "Convert mol2 file to frcmod file"
parmchk2 -i $mol2_file \
         -f mol2 \
         -o $frcmod_file \
         -s gaff2 &> log/convert_mol2_to_frcmod.log

# cp $prefix/FMN/output/B3LYP_dp_9/forcefield/FMN_resp.frcmod $frcmod_file

if [ ! -e input/2PR5.pdb ]; then
  wget "https://files.rcsb.org/download/2PR5.pdb" -P input/
fi

python3 convert_fmn.py input/2PR5.pdb output/FMN_taken_out_of_original.pdb

# leapin require
#  - output/FMN.mol2
#  - output/FMN.frcmod
#  - input/protein.pdb
#  - output/FMN_taken_out_of_original.pdb
# tleap output
#  - output/system.dry.pdb
#  - output/system.pdb
#  - output/system.prmtop
#  - output/system.crd
#  - output/leap.log
echo "Run leap to get amber input files"
tleap -f input/leapin &> log/leap_stdout.log

# Check system summary
# for system in system.dry system; do
#   parmed \
#     --parm output/${system}.prmtop \
#     --inpcrd output/${system}.crd \
#     --input input/parmed.input \
#     --no-splash \
#     > log/${system}_parmed.log
# done
