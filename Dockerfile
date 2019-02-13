FROM centos:7

#Install prereqs and download ATS
RUN yum install -y wget bzip2 gcc gcc-c++ pkgconfig pcre-devel tcl-devel expat-devel openssl-devel autoconf automake libtool make
RUN wget https://archive.apache.org/dist/trafficserver/trafficserver-7.1.4.tar.bz2 && tar -xvjf trafficserver-7.1.4.tar.bz2

#Build ATS
RUN cd /trafficserver-7.1.4 && ./configure && make && make install

#Add Signal Sciences yum repository and install Agent and ATS Module
COPY sigsci.repo /etc/yum.repos.d/sigsci.repo
RUN yum install -y sigsci-agent sigsci-module-ats

#Install Apache for test server
RUN yum install -y httpd

#Copy ATS config files
COPY plugin.config /usr/local/etc/trafficserver/plugin.config
COPY remap.config /usr/local/etc/trafficserver/remap.config
#sigsci.config is optional, only used if changing Module config flags
COPY sigsci.config /usr/local/etc/trafficserver/sigsci.config

COPY test.html /var/www/html/test.html

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
