FROM kaixhin/cuda-torch:8.0

# this step takes ages so let's make a layer from it
RUN git clone --depth 1 https://github.com/jcjohnson/fast-neural-style.git \
    && luarocks install torch \
    && luarocks install nn \
    && luarocks install image \
    && luarocks install lua-cjson \
    && luarocks install cutorch \
    && luarocks install cunn \
    && luarocks install cudnn \
    && luarocks install camera \
    && luarocks install qtlua \
    && /root/torch/update.sh

RUN cd fast-neural-style && bash models/download_style_transfer_models.sh \
    && apt-get update \
    && apt-get -y install openssh-server figlet vim \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i'' -e 's/^\(PermitRootLogin \).*/\1yes/' /etc/ssh/sshd_config \
    && sed -i'' -e "s/^\(\[ -z \"\$PS1\".*\)/#\1/" /root/.bashrc \
    && echo "root:p" | chpasswd \
    && echo 'source /exports.sh' >> /root/.bashrc

ADD start.sh /start.sh
ADD webcam.sh /webcam.sh
ADD common.sh /common.sh
ADD trainer.sh /trainer.sh
ADD exports.sh /exports.sh

WORKDIR /root/torch/fast-neural-style

CMD ["/start.sh"]


# ssh -X root@172.17.0.2 "cd /root/torch/fast-neural-style/ && /root/torch/install/bin/qlua webcam_demo.lua -models models/eccv16/starry_night.t7 -gpu 0"

# nvidia-docker run --device=/dev/video0 -it fastn
