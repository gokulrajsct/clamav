  
FROM registry.redhat.io/ubi8/ubi

#RUN  rpm --import http://download.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-8
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN  yum -y install epel-release
RUN  yum clean all
RUN  yum install -y clamav-server clamav-data clamav-update clamav-filesystem clamav clamav-scanner-systemd clamav-devel clamav-lib clamav-server-systemd

COPY config/clamd.conf /etc/clamd.conf
COPY config/freshclam.conf /etc/freshclam.conf

RUN chgrp -R 0 /var/lib/clamav
RUN chmod -R ug+rwx /var/lib/clamav
#RUN mkdir -p /var/log/clamav

RUN    set -x \
    && cd /var/lib/clamav \
    && curl -O http://database.clamav.net/main.cvd \
    && curl -O http://database.clamav.net/daily.cvd \
    && curl -O http://database.clamav.net/bytecode.cvd \
    && curl -O http://database.clamav.net/safebrowsing.cvd \
    && chown -R clamavupdate:clamavupdate /var/lib/clamav/*.cvd


#RUN wget -t 5 -T 99999 -O /var/lib/clamav/main.cvd http://database.clamav.net/main.cvd && \
 #  wget -t 5 -T 99999 -O /var/lib/clamav/daily.cvd http://database.clamav.net/daily.cvd && \
  # wget -t 5 -T 99999 -O /var/lib/clamav/bytecode.cvd http://database.clamav.net/bytecode.cvd && \
   #chown -R clamavupdate:clamavupdate /var/lib/clamav/*.cvd
   
#RUN chmod -R g+wrx /dev/stdout && chgrp -R 0 /dev/stdout
   #chmod -R g=u /var/log/clamav && chmod -R g=u /var/lib/clamav && \
 #  chmod -R g+wrx /var/log/clamav

USER 1001

EXPOSE 3310

CMD clamd -c /etc/clamd.conf
