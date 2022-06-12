#!/bin/bash 

utils=/alt-arabic/speech/amir/kaldi/egs/wsj/s5/utils
cmd=/alt-arabic/speech/amir/kaldi/egs/wsj/s5/utils/parallel/slurm.pl
nj=10
in_file=/alt-arabic/speech/amir/8KHz_plp/data8/dev/text.utf8
logdir=exp
mkdir -p $logdir

# split file to number of jobs
split_scps=
for n in $(seq $nj); do
    split_scps="$split_scps $logdir/out.$n"
done
$utils/split_scp.pl $in_file $split_scps

# run array jobs 
$cmd JOB=1:$nj $logdir/log/out.JOB.log \
    ./transcript_cleaning.py $logdir/out.JOB False $logdir/out_clean.JOB

# Concatenate the files together.
for n in $(seq $nj); do
  cat $logdir/out_clean.$n
done > $logdir/text.cleaned

# check if all lines were processed
nf=$(wc -l < $in_file)
nu=$(wc -l < $logdir/text.cleaned)
if [ $nf -ne $nu ]; then
  echo "$0: It seems not all of the lines were successfully procesed" 
fi