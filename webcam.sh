#!/bin/bash
. /common.sh
ADDITIONAL_ARGS="${@:--models models/eccv16/starry_night.t7}"
/root/torch/install/bin/qlua webcam_demo.lua -gpu 0 $ADDITIONAL_ARGS
