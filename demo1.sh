#!/bin/bash


MINUTES=2
models=`echo -e "1Sykora-JAZ20f35a_Zdenek_Sykora_Seda_struktura2\n
2matrix\n
starry_night\n
misc-openshift\n
california-1967\n
dots-2004\n
grid-mounted-1921\n
ile-de-br-hat-1911-1\n
inner-view-3-1955\n
no-5-1952\n
now-a-turning-orb\n
portrait-de-jacques-nayral-1911\n
1Sykora-_MG_9335-2\n
1other-bluesomething\n
Escher-division\n
the_scream\n
1Sykora-zdenek-sykora-serigrafie\n
2other-pattern3\n
Escher-fishes-and-scales2\n
Mondrian-mill-in-sunlight-the-winkel-mill-1908\n
2matrix\n
2other-pattern\n
Escher-horseman-1\n
Mucha-the-autumn-1896 \n
2other-metal\n
2other-taxi-cab-ii-1959\n
LFreud-self-portrait-reflection-2004\n
Picasso-portrait-of-dora-maar-1937-1" | shuf`

docker kill `docker ps -q` &> /dev/null

# start the container and mount the models
make run-cont-mount


for model in $models;
do
  echo -e "\n\n\nFor terminating hold CTRL+C for a second\n\n\nor create an empty file called stop: touch stop\n\n"

  if [ -e stop ] ; then
    echo "Exiting on request"
    rm -f stop
    exit 0
  fi

  (sleep $[$MINUTES * 60] && pkill ssh &> /dev/null; pkill eog &> /dev/null)&
  (sleep 2 && eog /home/jkremser/good-models/$model.jpg) &
  ssh -X -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' fns` /webcam.sh -models /tmp/data/models/$model.t7 -width 800 -height 600
  sleep 2
done
