#!/bin/sh -xeu
#PJM -L rscgrp=cx-share
#PJM -L gpu=1
#PJM -L elapse=00:30:00
#PJM --mpi proc=1
#PJM -S
#PJM -j

. $YTVA_DARK_PROTONATED_PREFIX/2equilibrium/run.sh $PJM_BULKNUM
