FROM kaixhin/cuda-torch:7.5

ADD start.sh /start.sh

# fetch fast neural style
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
    && cd fast-neural-style && bash models/download_style_transfer_models.sh \
    && apt-get update \
    && apt-get -y install openssh-server \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i'' -e 's/^\(PermitRootLogin \).*/\1yes/' /etc/ssh/sshd_config \
    && echo "root:root" | chpasswd
    # && echo -e "root\nroot\n" | passwd

WORKDIR /root/torch/fast-neural-style

CMD ["/start.sh"]


# ssh -X root@172.17.0.2 "cd /root/torch/fast-neural-style/ && /root/torch/install/bin/qlua webcam_demo.lua -models models/eccv16/starry_night.t7 -gpu 0"

# nvidia-docker run --device=/dev/video0 -it fastn
