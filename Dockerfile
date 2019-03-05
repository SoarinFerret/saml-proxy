FROM centos:7

RUN yum install -y \
  openssl \
  httpd \
  mod_auth_mellon-diagnostics \
  mod_ssl \
  gettext \
  wget \
  && yum clean all \
  && mkdir /etc/httpd/mellon

# Add mod_auth_mellon setup script
ADD https://raw.githubusercontent.com/Uninett/mod_auth_mellon/master/mellon_create_metadata.sh /usr/sbin/mellon_create_metadata.sh

# Give execute permissions
RUN chmod +x /usr/sbin/mellon_create_metadata.sh

# Add conf file for Apache
ADD proxy.conf /etc/httpd/conf.d/proxy.conf.template

RUN echo 'LoadModule auth_mellon_module modules/mod_auth_mellon-diagnostics.so' > /etc/httpd/conf.modules.d/10-auth_mellon.conf

EXPOSE 80

ADD configure /usr/sbin/configure
ENTRYPOINT /usr/sbin/configure
