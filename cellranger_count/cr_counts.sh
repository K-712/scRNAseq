#!/bin/bash --login
set -euo pipefail 

# USAGE:
# Move cr_counts.sh and create_cr_counts_slurm.sh to the output directory (i.e. ${SLURM_OUTPUT}).
# Change the  parameters below. 
# All paths should be absolute and start with the root dir.

# ${SAMPLES} should be a list of sample names. These are given to cellranger as the IDs. 
# This script assumes the sample sheet is a csv with a header row and the sample names are in the 2nd column. 

# ${FASTQ_PREFIX} should be the fastq path from cellranger mkfastq. Needs a trailing /. 
# Inside this fastq dir should be directories named in line with the sample names. 
# If not, run the following to create the directories and move files over. 
# for i in `tail -n +2 <samplesheet> | awk -F ',' '{print $2}'`; do mkdir ${i}; mv ${i}*fastq.gz ${i}/; done

# ${TRANSCRIPTOME} should be the path to cellranger reference directory (no trailing / ). 

# ${SLURM_OUTPUT} is the directory in which output files will be placed, and will also be where slurm's log data is. This script and create_cr_counts_slurm.sh should be in this directory. 

# ${EMAIL} is the email slurm scheduler will be sending status updates to. 

# slurm module should be loaded

SAMPLES=(`tail -n +2 </path/to/samplesheet> | awk -F ',' '{print $2}'`)
FASTQ_PREFIX="/path/to/fastqdir/"
TRANSCRIPTOME="/path/to/refdir"
SLURM_OUTPUT="/path/to/output/"
EMAIL="email@email.com"

for i in "${SAMPLES[@]}"
do
  bash create_cr_counts_slurm.sh ${i} ${FASTQ_PREFIX} ${TRANSCRIPTOME} ${SLURM_OUTPUT} ${EMAIL} > counts_${i}.slurm
  sbatch counts_${i}.slurm
done