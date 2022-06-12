#!/bin/bash
cd /home/local/QCRI/ahussein/slurm_tutorials
. ./path.sh
( echo '#' Running on `hostname`
  echo '#' Started at `date`
  set | grep SLURM | while read line; do echo "# $line"; done
  echo -n '# '; cat <<EOF
./transcript_cleaning.py exp/out.${SLURM_ARRAY_TASK_ID} False exp/out_clean.${SLURM_ARRAY_TASK_ID} 
EOF
) >exp/log/out.$SLURM_ARRAY_TASK_ID.log
if [ "$CUDA_VISIBLE_DEVICES" == "NoDevFiles" ]; then
  ( echo CUDA_VISIBLE_DEVICES set to NoDevFiles, unsetting it... 
  )>>exp/log/out.$SLURM_ARRAY_TASK_ID.log
  unset CUDA_VISIBLE_DEVICES
fi
time1=`date +"%s"`
 ( ./transcript_cleaning.py exp/out.${SLURM_ARRAY_TASK_ID} False exp/out_clean.${SLURM_ARRAY_TASK_ID}  ) &>>exp/log/out.$SLURM_ARRAY_TASK_ID.log
ret=$?
sync || true
time2=`date +"%s"`
echo '#' Accounting: begin_time=$time1 >>exp/log/out.$SLURM_ARRAY_TASK_ID.log
echo '#' Accounting: end_time=$time2 >>exp/log/out.$SLURM_ARRAY_TASK_ID.log
echo '#' Accounting: time=$(($time2-$time1)) threads=1 >>exp/log/out.$SLURM_ARRAY_TASK_ID.log
echo '#' Finished at `date` with status $ret >>exp/log/out.$SLURM_ARRAY_TASK_ID.log
[ $ret -eq 137 ] && exit 100;
touch exp/q/done.457.$SLURM_ARRAY_TASK_ID
exit $[$ret ? 1 : 0]
## submitted with:
# sbatch --ntasks-per-node=1 --partition=gpu-all   --open-mode=append -e exp/q/out.log -o exp/q/out.log --array 1-10 /home/local/QCRI/ahussein/slurm_tutorials/exp/q/out.sh >>exp/q/out.log 2>&1
