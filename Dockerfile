FROM openshift/base-centos7


RUN yum -y install epel-release
RUN yum clean all
RUN yum install -y clamav-server clamav-data clamav-update clamav-filesystem clamav clamav-scanner-systemd clamav-devel clamav-lib clamav-server-systemd

COPY config/clamd.conf /etc/clamd.conf
COPY config/freshclam.conf /etc/freshclam.conf

#RUN chgrp -R 0 /var/lib/clamav/
#RUN chmod -R ug+rwx /var/lib/clamav/
RUN mkdir -p /var/log/clamav

RUN wget -t 5 -T 99999 -O /var/lib/clamav/main.cvd http://database.clamav.net/main.cvd && \
   wget -t 5 -T 99999 -O /var/lib/clamav/daily.cvd http://database.clamav.net/daily.cvd && \
   wget -t 5 -T 99999 -O /var/lib/clamav/bytecode.cvd http://database.clamav.net/bytecode.cvd && \
   chgrp -R 0 /var/lib/clamav/*.cvd
RUN chgrp -R 0 /var/log/clamav && chgrp -R 0 /var/lib/clamav && \
   chmod -R g=u /var/log/clamav && chmod -R g=u /var/lib/clamav && \
   chmod -R g+wrx /var/log/clamav && chmod -R g+wrx /var/lib/clamav

USER 1001

EXPOSE 3310

CMD clamd -c /etc/clamd.conf
