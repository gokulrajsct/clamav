FROM registry.redhat.io/rhel7/rhel

ARG VERSION
ENV VERSION=${VERSION}

#RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN  yum -y install epel-release
RUN  yum clean all
RUN  yum install -y clamav-server clamav-data clamav-update clamav-filesystem clamav clamav-scanner-systemd clamav-devel clamav-lib clamav-server-systemd

COPY config/clamd.conf /etc/clamd.conf
COPY config/freshclam.conf /etc/freshclam.conf

RUN chgrp -R 0 /var/lib/clamav
RUN chmod -R ug+rwx /var/lib/clamav
#RUN mkdir -p /var/log/clamav

	
USER 1001

EXPOSE 3310

CMD clamd -c /etc/clamd.conf

EXPOSE 3310

CMD clamd -c /etc/clamd.conf
