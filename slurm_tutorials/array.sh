#!/bin/bash

sbatch --array=1-30 -w crimv3srv037 -n1 --wrap="sleep 60"