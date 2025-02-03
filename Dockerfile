#FROM registry.access.redhat.com/ubi8/ubi-minimal

FROM example-registry-quay-quay.apps.rosa-mqc4s.nkv5.p1.openshiftapps.com/quayuser1/ubitest:v.9.4

RUN dnf update pam

ENV HOME /root

WORKDIR /root

CMD tail -f /dev/null
