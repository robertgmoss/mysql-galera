# version 0.0.1
FROM ubuntu:14.04
MAINTAINER Robert Moss "robert.moss@cloudsoftcorp.com"
RUN apt-get update
RUN apt-get install -y python-software-properties
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv BC19DDBA
RUN echo deb http://releases.galeracluster.com/ubuntu trusty main >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y galera-3 galera-arbitrator-3 mysql-wsrep-5.6 rsync
COPY my.cnf /etc/mysql/my.cnf
COPY wsrep.cnf /etc/mysql/conf.d/wsrep.cnf
ADD init_db.sh /tmp/init_db.sh
RUN chmod +x /tmp/init_db.sh
RUN /tmp/init_db.sh
EXPOSE 3306
ENTRYPOINT ["mysqld"]
