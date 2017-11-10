LOCAL_IMAGE=$(USER)/fast-neural-style

.PHONY: build clean run run-cont run-net

build:
	docker build -t $(LOCAL_IMAGE) .

clean:
	-docker rmi -f $(LOCAL_IMAGE) || true

run-cont:
	-docker rm -f fns || true
	nvidia-docker run -d --name fns --device=/dev/video0 $(LOCAL_IMAGE)
	sleep 1

run-net:
	echo -e "\n\nPassword: p\n\n"
	ssh -X -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' fns` "cd /root/torch/fast-neural-style/ && /root/torch/install/bin/qlua webcam_demo.lua -models models/eccv16/starry_night.t7 -gpu 0"

run: run-cont run-net
