## @author     Dmitry Kolesnikov, <dmkolesnikov@gmail.com>
## @copyright  (c) 2014 Dmitry Kolesnikov. All Rights Reserved
##
## @description
##   tpc-c benchmark suite 
FROM centos
MAINTAINER Dmitry Kolesnikov <dmkolesnikov@gmail.com>

##
## install dependencies
RUN \
   yum -y install \
      bzr   \
      gcc   \
      make  \
      mysql \
      mysql-devel

##
## clone tools
RUN \
   cd /root && \
   bzr branch lp:~percona-dev/perconatools/tpcc-mysql

##
## make tools
RUN \
   cd /root/tpcc-mysql/src && \
   make

COPY run.sh /run.sh

ENTRYPOINT ["sh", "/run.sh"]