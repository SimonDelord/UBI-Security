#FROM registry.access.redhat.com/ubi8/ubi-minimal

FROM example-registry-quay-quay.apps.rosa-mqc4s.nkv5.p1.openshiftapps.com/quayuser1/ubitest

RUN \
  dnf remove libxml2
  && dnf clean all

ENV HOME /root

WORKDIR /root

CMD tail -f /dev/null
