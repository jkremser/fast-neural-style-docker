#!/bin/bash
ADDITIONAL_ARGS="${@:--models models/eccv16/starry_night.t7}"

for l in `cat /env`; do export $l; done

cd /root/torch/fast-neural-style/
export CUDNN_PATH="/tmp/cuda/lib64/libcudnn.so"
/root/torch/install/bin/qlua webcam_demo.lua -gpu 0 $ADDITIONAL_ARGS
