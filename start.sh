#!/bin/bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/nvidia/lib/

service ssh restart

figlet neural style
echo -e "------------------------------------------------------\n\n\nContainer has started..\n"
echo -e "Feel free to use ssh -X root@`hostname -i`\nUsername: root\nPassword: p"

# take a rest
sleep $[60*60*24]
