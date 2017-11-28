LOCAL_IMAGE=$(USER)/fast-neural-style:demo
SSH_PARAMS=-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' fns`
SSH_RUN_COMMAND=ssh -X $(SSH_PARAMS)

.PHONY: build clean run run-cont attach copy-id webcam1 webcam2 webcam3

build:
	docker build -t $(LOCAL_IMAGE) .

clean:
	-docker rmi -f $(LOCAL_IMAGE) || true

run-cont:
	-docker rm -f fns || true
	nvidia-docker run --rm -d --name fns2 --device=/dev/video0 $(LOCAL_IMAGE)
	sleep 1

attach:
	$(SSH_RUN_COMMAND) cd /root/torch/fast-neural-style/ && pwd && ls

copy-id:
	echo -e "\n\nPassword: p\n\n"
	ssh-copy-id $(SSH_PARAMS)

webcam0:
	$(SSH_RUN_COMMAND) /webcam.sh -models models/instance_norm/the_scream.t7

webcam1:
	$(SSH_RUN_COMMAND) /webcam.sh

webcam2:
	$(SSH_RUN_COMMAND) /webcam.sh -models models/eccv16/starry_night.t7,models/instance_norm/udnie.t7

webcam3:
	$(SSH_RUN_COMMAND) /webcam.sh -models models/instance_norm/udnie.t7,models/instance_norm/la_muse.t7,models/instance_norm/mosaic.t7,models/instance_norm/the_scream.t7

run: run-cont copy-id webcam1
