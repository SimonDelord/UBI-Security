##FROM example-registry-quay-quay.apps.rosa-mqc4s.nkv5.p1.openshiftapps.com/quayuser1/ubitest:v.9.4

##RUN dnf update pam -y

##ENV HOME /root

##WORKDIR /root

##CMD tail -f /dev/null


FROM quay.io/smileyfritz/roxctl:latest

ENV HOME /root

WORKDIR /root

CMD tail -f /dev/null
