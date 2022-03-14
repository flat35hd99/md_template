#!/bin/sh -xeu
#PJM -L rscgrp=cx-share
#PJM -L gpu=1
#PJM -L elapse=48:00:00
#PJM --mpi proc=1
#PJM -S
#PJM -j

. $YTVA_DARK_PREFIX/3sampling/run.sh $PJM_BULKNUM
