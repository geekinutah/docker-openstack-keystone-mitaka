FROM ubuntu:latest
MAINTAINER Mike Wilson <geekinutah@gmail.com>

ENV TERM=xterm-256color

COPY fix-requirements.py /usr/bin/fix-requirements.py
COPY libs.vers /libs.vers

RUN apt-get -q update >/dev/null \
  && apt-get install -y python python-dev curl build-essential git libssl-dev libmysqlclient-dev \
  && git clone --branch mitaka-eol https://github.com/openstack/keystone.git \
  && curl https://bootstrap.pypa.io/get-pip.py | python \
  && fix-requirements.py --map_file libs.vers --requirements_file keystone/requirements.txt --inplace \
  && pip install keystone/ \
  && pip install mysqlclient==1.3.4 \
  && pip install PyMySQL==0.6.7 \
  && pip install Jinja \
  && mkdir /etc/keystone
  # Cleanup
  && apt-get clean autoclean \
  && apt-get autoremove --yes \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/ 

COPY keystone.conf.j2 /etc/keystone/keystone.conf.j2

ENTRYPOINT ["/bin/bash"]
