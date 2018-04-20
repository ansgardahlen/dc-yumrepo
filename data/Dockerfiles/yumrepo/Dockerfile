# build stage

# application image
FROM centos:7
LABEL maintainer="Ansgar Dahlen <a.dahlen@da-rz.de>"

ARG TOKEN
ENV TOKEN "$TOKEN"

RUN yum localinstall -y http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm
RUN yum install -y createrepo_c git

RUN git clone https://$TOKEN@git.da-rz.net/darz/yumrepo.git

WORKDIR yumrepo

RUN scripts/init-virtualenv

EXPOSE 8080

WORKDIR /yumrepo

CMD . /yumrepo/ve/bin/activate && \
    /yumrepo/src/main/scripts/yumrepos


