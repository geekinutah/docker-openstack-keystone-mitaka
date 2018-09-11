FROM ubuntu:latest
MAINTAINER Mike Wilson <geekinutah@gmail.com>

ENV TERM=xterm-256color

COPY fix_requirements.py /fix_requirements.py
COPY libs.vers /libs.vers

RUN apt-get -q update >/dev/null \
  && apt-get install -y python python-dev curl build-essential git \
  && git clone --branch mitaka-eol https://github.com/openstack/keystone.git \
  && curl https://bootstrap.pypa.io/get-pip.py | python \
  && pip install keystone/ \

  # Cleanup
  && apt-get clean autoclean \
  && apt-get autoremove --yes \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/ 

ENTRYPOINT ["/bin/bash"]
