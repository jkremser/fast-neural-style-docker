#!/bin/bash
cd /root/torch/fast-neural-style/
/root/torch/install/bin/qlua webcam_demo.lua -models models/eccv16/starry_night.t7 -gpu 0
