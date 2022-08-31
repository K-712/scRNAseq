#!/bin/bash --login

i=${1}
FASTQ_PREFIX=${2}
TRANSCRIPTOME=${3}
SLURM_OUTPUT=${4}
EMAIL=${5} 

cat <<EOT
#!/bin/bash --login

#SBATCH --job-name=cr_count${i}
#SBATCH --export=ALL
#SBATCH --mail-user=${EMAIL}
#SBATCH --mail-type=ALL
#SBATCH --time=50:00:00
#SBATCH --output=${SLURM_OUTPUT}%x-%A_%a.out
#SBATCH --ntasks=1 --cpus-per-task=16
#SBATCH --mem=256G
#SBATCH --partition=compute

date
hostname 

module load cellranger-7.0.1
module list

echo "counting sample ${i}"
echo "cellranger count --id=${i} --fastqs=$FASTQ_PREFIX${i} --sample=${i} --transcriptome=$TRANSCRIPTOME --localcores=16 --localmem=240"
cellranger count --id=${i} --fastqs=$FASTQ_PREFIX${i} --sample=${i} --transcriptome=$TRANSCRIPTOME --localcores=16 --localmem=240 && echo "finished sample ${i}"

EOT