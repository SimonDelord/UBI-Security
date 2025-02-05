#FROM registry.access.redhat.com/ubi8/ubi-minimal

FROM example-registry-quay-quay.apps.rosa-mqc4s.nkv5.p1.openshiftapps.com/quayuser1/ubitest:v.9.5

RUN curl -sL "https://github.com/google/go-containerregistry/releases/download/v0.20.3/go-containerregistry_Linux_x86_64.tar.gz" > go-containerregistry.tar.gz

RUN tar -zxvf go-containerregistry.tar.gz -C /usr/local/bin/ crane


#RUN \
#  microdnf install \
#  net-tools bind-utils iputils curl git unzip vim wget \
#  && microdnf clean all

ENV HOME /root

WORKDIR /root

CMD tail -f /dev/null
