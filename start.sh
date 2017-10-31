#!/bin/bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/nvidia/lib/

service ssh restart
/bin/bash
