FROM ubuntu:16.04

LABEL maintainer="Nikita Gorlov"

RUN apt update && apt install -y wget unzip git python3-pip python-dev python-crypto && \
    pip3 install --upgrade pip && \
    python3 -m pip install ansible apache-libcloud PyCrypto google-auth && \
    wget https://releases.hashicorp.com/terraform/0.11.10/terraform_0.11.10_linux_amd64.zip -t 3 && \
    unzip terraform_0.11.10_linux_amd64.zip -d /usr/local/bin && \
    export PATH=/usr/local/bin:$PATH

CMD [ "/bin/bash" ]
