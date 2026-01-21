FROM ubuntu:noble

LABEL maintainer="CPS1 Tecnologia LTDA"
LABEL name="cps1/base-template"

RUN echo 'APT::Install-Recommends "false";' > /etc/apt/apt.conf.d/99no-recommends && \
    echo 'APT::Install-Suggests "false";' >> /etc/apt/apt.conf.d/99no-recommends && \
    DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt update && \
    apt -y upgrade && apt install --no-install-recommends -y \
    curl \
    wget \
    git \
    ssh-client \
    ca-certificates \
    iputils-ping \
    net-tools \
    unzip \
    zip \
    tzdata \
    sudo

RUN curl -o /tmp/vscodium.tar.gz \
    -L https://github.com/VSCodium/vscodium/releases/download/1.101.03933/vscodium-reh-web-linux-x64-1.101.03933.tar.gz && \
    mkdir /opt/codium && \
    tar xzf /tmp/vscodium.tar.gz -C /opt/codium && \
    ln -s /opt/codium/bin/codium-server /usr/local/bin/codium-server && \
    rm /tmp/vscodium.tar.gz

RUN echo "user ALL=NOPASSWD: /usr/bin/apt-get,/usr/bin/apt" >> /etc/sudoers

RUN useradd user -s /bin/bash -m -u 10001

CMD ["/bin/bash"]
