#!/bin/bash 
#SBATCH -J array #job name
#SBATCH -t 2:00
##SBATCH --mail-user=anh21@mail.aub.edu
##SBATCH --mail-type=end
#SBATCH -o output-%A_%a.txt #standard output file
##SBATCH -e errors-%A_%a.txt #standard error file
#SBATCH -p gpu-all #queue used
##SBATCH --gres gpu:2 #number of gpus needed
#SBATCH -N 1
#SBATCH -n 1
#SBATCH  --cpus-per-task=2
#SBATCH --mem=6G

# Submit a job array 
#SBATCH -a 1-30


steps=/alt-arabic/speech/amir/kaldi/egs/wsj/s5/steps
utils=/alt-arabic/speech/amir/kaldi/egs/wsj/s5/utils
sleep 10
echo "Task id is $SLURM_ARRAY_TASK_ID"