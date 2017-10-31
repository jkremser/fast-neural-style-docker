LOCAL_IMAGE=$(USER)/fast-neural-style

.PHONY: build clean run

build: clean
	docker build -t $(LOCAL_IMAGE) .

clean:
	-docker rmi -f $(LOCAL_IMAGE) || true

run:
	-docker rm -f fns || true
	nvidia-docker run --name fns --device=/dev/video0 -it $(LOCAL_IMAGE)
	sleep 2
	ssh -X root@`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' fns` "cd /root/torch/fast-neural-style/ && /root/torch/install/bin/qlua webcam_demo.lua -models models/eccv16/starry_night.t7 -gpu 0"
