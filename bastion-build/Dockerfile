FROM registry.access.redhat.com/ubi9/ubi:latest

RUN \
  dnf install git unzip wget -y \
  && dnf clean all

## Install Go

RUN wget https://go.dev/dl/go1.24.1.linux-amd64.tar.gz
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.24.1.linux-amd64.tar.gz
RUN export PATH=$PATH:/usr/local/go/bin
RUN go version

## Install cosign

RUN go install github.com/sigstore/cosign/v2/cmd/cosign@latest
RUN cosign version

## Install Crane

RUN go install github.com/google/go-containerregistry/cmd/crane@latest
RUN crane version

## Install Rekor-cli

RUN go install -v github.com/sigstore/rekor/cmd/rekor-cli@latest
RUN rekor-cli version

## Install syft

RUN curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh
RUN sh -s -- -b /usr/local/bin


ENV HOME /root

WORKDIR /root

CMD tail -f /dev/null
