#!/usr/bin/env -S bash -c "docker run -v \${PWD}:/app --rm --cap-drop=all -it \$(docker build -q docker) \$@"
FROM ubuntu:22.04

WORKDIR /app

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y gnupg software-properties-common curl \
    && curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - \
    && apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" \
    && apt-get update \
    && apt-get install -y nano jq zip make \
    && apt-get install -y terraform \
    && apt-get install -y python3-venv \
    && apt-get install -y openssh-client \
    && apt autoclean \
    && apt autoremove \
    && apt clean \
    && curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws

# safety measure to drop privileges to lowly user
RUN useradd -ms /bin/bash runuser
USER runuser

CMD ./scripts/aws-authenticated-bash.sh


